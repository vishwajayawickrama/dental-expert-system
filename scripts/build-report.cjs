// Report authoring only; this does not implement the expert system.
// Run with the Codex bundled Node runtime and NODE_PATH pointing to its packages.
// TikZ rendering requires XeLaTeX, Times New Roman and pdftoppm.
// For matching PDF conversion, expose the installed Times New Roman fonts through
// an isolated FONTCONFIG_FILE and audit PDF BaseFont names to prevent substitution.
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const d = require('docx');
const ROOT = path.resolve(__dirname,'..');
const OUT = path.join(ROOT,'docs/report');
const data = JSON.parse(fs.readFileSync(path.join(ROOT,'build/report/data.json'),'utf8'));
if(data.facts.length!==30||data.rules.length!==25||data.questions.length!==27||data.cases.length!==20||data.cases.some(c=>!c.pass))throw Error('Knowledge or acceptance mismatch');
fs.mkdirSync(OUT,{recursive:true});
const children=[];
const W=9360;
function runs(text,opts={}){
  return text.split(/(\*\*[^*]+\*\*|`[^`]+`)/g).filter(Boolean).map(t=>new d.TextRun({...opts,text:t.replace(/^\*\*|\*\*$|^`|`$/g,''),bold:t.startsWith('**')||opts.bold,font:'Times New Roman'}));
}
function p(text,opts={}){children.push(new d.Paragraph({children:runs(text),spacing:{after:120,line:270},...opts}));}
function heading(text,level=1){children.push(new d.Paragraph({text,heading:level===1?d.HeadingLevel.HEADING_1:d.HeadingLevel.HEADING_2,pageBreakBefore:level===1||text==='4.2 Implemented components',keepNext:true,spacing:{before:level===1?0:220,after:140}}));}
function table(headers,rows,widths,small=false){
  widths=widths||headers.map(()=>W/headers.length);
  let all=[headers,...rows];
  children.push(new d.Table({width:{size:W,type:d.WidthType.DXA},columnWidths:widths,
    borders:Object.fromEntries(['top','bottom','left','right','insideHorizontal','insideVertical'].map(k=>[k,{style:d.BorderStyle.SINGLE,size:4,color:'000000'}])),
    rows:all.map((row,i)=>new d.TableRow({tableHeader:i===0,cantSplit:true,children:row.map((text,j)=>new d.TableCell({
      width:{size:widths[j],type:d.WidthType.DXA},verticalAlign:d.VerticalAlign.CENTER,
      shading:{fill:'FFFFFF'},margins:{top:65,bottom:65,left:100,right:100},
      children:[new d.Paragraph({spacing:{after:0,line:small?210:225},children:[new d.TextRun({text:String(text),font:'Times New Roman',size:small?18:20,bold:i===0,color:'000000'})]})]
    }))}))}));
  children.push(new d.Paragraph({spacing:{after:80},children:[]}));
}
function picture(file,caption){
  const bytes=fs.readFileSync(path.join(ROOT,'docs',file));
  const {width,height}=require('image-size').imageSize(bytes);
  const displayWidth=624,displayHeight=Math.round(displayWidth*height/width);
  children.push(new d.Paragraph({alignment:d.AlignmentType.CENTER,keepNext:true,spacing:{before:120,after:80},children:[new d.ImageRun({type:'png',data:bytes,transformation:{width:displayWidth,height:displayHeight},altText:{title:caption,description:caption,name:caption}})]}));
  p(caption,{style:'Caption',keepNext:true,alignment:d.AlignmentType.CENTER});
}
async function diagram(){
  const dir=path.join(ROOT,'build/report/diagram');
  fs.mkdirSync(dir,{recursive:true});
  execFileSync(process.env.DENTAL_TEX || 'xelatex',['-interaction=nonstopmode','-halt-on-error','-output-directory='+dir,path.join(ROOT,'docs/report-assets/architecture.tex')],{stdio:'pipe'});
  execFileSync(process.env.DENTAL_PDFTOPPM || 'pdftoppm',['-singlefile','-png','-r','200',path.join(dir,'architecture.pdf'),path.join(ROOT,'docs/report-assets/architecture')],{stdio:'pipe'});
}
async function main(){
 await diagram();
 children.push(new d.Paragraph({text:'DentalExplain',style:'Title',spacing:{before:2300,after:280},alignment:d.AlignmentType.CENTER}));
 p('A Dental Diagnosis Expert System',{alignment:d.AlignmentType.CENTER,spacing:{after:1500},children:[new d.TextRun({text:'A Dental Diagnosis Expert System',font:'Times New Roman',size:32})]});
 for(const t of ['Vishwa Jayawickrama','CM3321','Logic Programming and Artificial Cognitive Systems','29 September 2026'])p(t,{alignment:d.AlignmentType.CENTER});
 p('Application 1.3.0   Knowledge 0.4.0',{alignment:d.AlignmentType.CENTER,spacing:{before:700,after:120}});
 const text=fs.readFileSync(path.join(ROOT,'docs/report.md'),'utf8');
 const tokens=require('marked').lexer(text);
 let contentsInserted=false;
 for(const t of tokens){
   if(t.type==='heading'){
     if(t.text==='1 Introduction'&&!contentsInserted){
       children.push(new d.Paragraph({text:'Contents',style:'TOCHeading',pageBreakBefore:true,keepNext:true,spacing:{after:140}}));
       children.push(new d.TableOfContents('Table of Contents',{headingStyleRange:'1-1',hyperlink:true}));
       contentsInserted=true;
     }
     heading(t.text,t.depth);
   } else if(t.type==='paragraph'){
     const m=t.text.match(/^!\[([^\]]+)\]\(([^)]+)\)$/);
     if(m)picture(m[2],m[1]);else p(t.text.replace(/\[([^\]]+)\]\(([^)]+)\)/g,'$1 ($2)'));
   } else if(t.type==='table')table(t.header.map(c=>c.text),t.rows.map(r=>r.map(c=>c.text)));
   else if(t.type==='code'){
     for(const line of t.text.split('\n'))children.push(new d.Paragraph({spacing:{after:0,line:225},children:[new d.TextRun({text:line,font:'Times New Roman',size:18})]}));
     p('');
   } else if(t.type==='list'){
     t.items.forEach((item,i)=>p(`${t.ordered?(t.start||1)+i+'.':'•'} ${item.text}`,{indent:{left:200,hanging:200}}));
   }
 }
 heading('Appendix C Knowledge Catalogue');
 p('These records are exported directly from the implemented Prolog catalogue. All 30 facts and 25 production rules retain pending clinical review status. Consultation observations, question schemas and test fixtures are not counted as domain facts.');
 heading('C.1 Authored domain facts',2);
 table(['ID','Domain statement','Source'],data.facts.map(f=>[f.id,f.description,f.source]),[600,7760,1000]);
 heading('C.2 Production rules',2);
 p('Premise notation: eq is equality; gt/gte/lte compare numeric findings; derived requires an intermediate deduction; kb refers to a domain fact. Every listed premise must hold. Internal gum, trigger and warning identifiers come from checkbox expansion.');
 for(const r of data.rules){
   children.push(new d.Paragraph({keepNext:true,spacing:{before:80,after:45},children:[new d.TextRun({text:r.id.toUpperCase()+'   '+r.conclusion,bold:true,font:'Times New Roman',size:21})]}));
   p('IF '+r.premises.join(' AND ')+' THEN '+r.conclusion+'.',{children:runs('IF '+r.premises.join(' AND ')+' THEN '+r.conclusion+'.',{size:20}),keepLines:true,spacing:{after:35,line:220}});
 }
 const doc=new d.Document({creator:'Vishwa Jayawickrama',title:'DentalExplain Report',description:'Dental diagnosis expert system report and user manual',
   styles:{default:{document:{run:{font:'Times New Roman',size:22,color:'000000'},paragraph:{spacing:{line:270,after:120}}}},paragraphStyles:[
     {id:'Title',name:'Title',basedOn:'Normal',run:{font:'Times New Roman',size:48,bold:true,color:'000000'}},
     {id:'Heading1',name:'Heading 1',basedOn:'Normal',next:'Normal',run:{font:'Times New Roman',size:30,bold:true,color:'000000'},paragraph:{outlineLevel:0}},
     {id:'Heading2',name:'Heading 2',basedOn:'Normal',next:'Normal',run:{font:'Times New Roman',size:24,bold:true,color:'000000'},paragraph:{outlineLevel:1}},
     {id:'TOCHeading',name:'TOC Heading',basedOn:'Normal',next:'Normal',run:{font:'Times New Roman',size:30,bold:true,color:'000000'},paragraph:{outlineLevel:9}},
     {id:'TOC1',name:'toc 1',basedOn:'Normal',next:'Normal',run:{font:'Times New Roman',size:22,color:'000000'},paragraph:{spacing:{after:155},tabStops:[{type:d.TabStopType.RIGHT,position:W,leader:d.LeaderType.DOT}]}},
     {id:'Caption',name:'Caption',basedOn:'Normal',run:{font:'Times New Roman',size:19,color:'000000'},paragraph:{spacing:{after:120,line:225}}}
   ]},features:{updateFields:true},sections:[{properties:{page:{size:{width:11906,height:16838},margin:{top:1100,right:1273,bottom:1100,left:1273}}},footers:{default:new d.Footer({children:[new d.Paragraph({alignment:d.AlignmentType.CENTER,children:[new d.TextRun({children:[d.PageNumber.CURRENT],font:'Times New Roman',size:18})]})]})},children}]});
 fs.writeFileSync(path.join(OUT,'DentalExplain Report.docx'),await d.Packer.toBuffer(doc));
 console.log('Report authored with 30 facts, 25 rules, 20 executed cases and 7 figures; acceptance details remain outside the report.');
}
main().catch(e=>{console.error(e);process.exit(1)});
