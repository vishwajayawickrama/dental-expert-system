#!/usr/bin/env python3
"""Make exported report contents rows clickable, including their page numbers."""
import argparse
from pathlib import Path
from zipfile import ZipFile

import pdfplumber
from lxml import etree
from pypdf import PdfReader, PdfWriter
from pypdf.generic import DictionaryObject, NameObject, RectangleObject


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pdf", type=Path)
    parser.add_argument("--docx", required=True, type=Path)
    args = parser.parse_args()
    with ZipFile(args.docx) as archive:
        root = etree.fromstring(archive.read("word/document.xml"))
    ns = {"w": root.nsmap["w"]}
    controls = root.xpath(
        './/w:sdt[w:sdtPr/w:docPartObj/w:docPartGallery[@w:val="Table of Contents"]]',
        namespaces=ns,
    )
    if len(controls) != 1:
        raise ValueError("Expected one native Word contents table")
    entries = []
    for paragraph in controls[0].find("w:sdtContent", ns)[1:]:
        values = paragraph.xpath(".//w:t/text()", namespaces=ns)
        entries.append(("".join(values[:-1]), int(values[-1]) - 1))

    reader = PdfReader(args.pdf)
    toc_pages = [i for i, p in enumerate(reader.pages)
                 if "Contents" in p.extract_text().splitlines()]
    if len(toc_pages) != 1:
        raise ValueError("Expected one contents page")
    toc_index = toc_pages[0]
    writer = PdfWriter()
    writer.clone_document_from_reader(reader)
    page = writer.pages[toc_index]
    links = sorted((a.get_object() for a in page.get("/Annots", [])
                    if a.get_object().get("/Subtype") == "/Link"),
                   key=lambda a: -float(a["/Rect"][3]))
    if len(links) != len(entries):
        raise ValueError("Exported contents links do not match Word entries")
    with pdfplumber.open(args.pdf) as pdf:
        words = pdf.pages[toc_index].extract_words()
        right = max(word["x1"] for word in words) + 2
    for link, (label, target) in zip(links, entries):
        if label not in reader.pages[target].extract_text().splitlines():
            raise ValueError(f"Wrong destination for {label}")
        destination = link.get("/Dest")
        if destination is None:
            destination = link["/A"]["/D"]
        expected_ref = writer.pages[target].indirect_reference
        if destination[0] != expected_ref:
            raise ValueError(f"Exported link targets the wrong page: {label}")
        left, bottom, _, top = map(float, link["/Rect"])
        link[NameObject("/Rect")] = RectangleObject(
            [left - 2, bottom - 2, right, top + 2])
        link[NameObject("/A")] = DictionaryObject({
            NameObject("/S"): NameObject("/GoTo"),
            NameObject("/D"): destination,
        })
        link.pop(NameObject("/Dest"), None)
        link[NameObject("/H")] = NameObject("/I")
    temporary = args.pdf.with_suffix(".linked.tmp.pdf")
    with temporary.open("wb") as output:
        writer.write(output)
    temporary.replace(args.pdf)
    print(f"Enabled {len(links)} full-row internal contents links in {args.pdf}")


if __name__ == "__main__":
    main()
