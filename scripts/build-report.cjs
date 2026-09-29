// Report authoring only; this does not implement the expert system.
// Run with the Codex bundled Node runtime and NODE_PATH pointing to its packages.
const fs = require('node:fs');
const path = require('node:path');
const {execFileSync} = require('node:child_process');
const sharp = require('sharp');
const d = require('docx');
const ROOT = path.resolve(__dirname,'..');
const OUT = path.join(ROOT,'docs/report');
const data = JSON.parse(fs.readFileSync(path.join(ROOT,'build/report/data.json'),'utf8'));
if(data.facts.length!==30||data.rules.length!==25||data.questions.length!==30||data.cases.length!==20||data.cases.some(c=>!c.pass))throw Error('Knowledge or acceptance mismatch');
fs.mkdirSync(OUT,{recursive:true});
const children=[];
const W=9360;
function runs(text,opts={}){
  return text.split(/(\*\*[^*]+\*\*|`[^`]+`)/g).filter(Boolean).map(t=>new d.TextRun({...opts,text:t.replace(/^\*\*|\*\*$|^`|`$/g,''),bold:t.startsWith('**')||opts.bold,font:t.startsWith('`')?'Courier New':opts.font}));
}
function p(text,opts={}){children.push(new d.Paragraph({children:runs(text),spacing:{after:120,line:270},...opts}));}
function heading(text,level=1){children.push(new d.Paragraph({text,heading:level===1?d.HeadingLevel.HEADING_1:d.HeadingLevel.HEADING_2,pageBreakBefore:level===1||text==='4.2 Implemented components',keepNext:true,spacing:{before:level===1?0:220,after:140}}));}
function table(headers,rows,widths,small=false){
  widths=widths||headers.map(()=>W/headers.length);
  let all=[headers,...rows];
  children.push(new d.Table({width:{size:W,type:d.WidthType.DXA},columnWidths:widths,
    borders:Object.fromEntries(['top','bottom','left','right','insideHorizontal','insideVertical'].map(k=>[k,{style:d.BorderStyle.SINGLE,size:4,color:'D9D9D9'}])),
    rows:all.map((row,i)=>new d.TableRow({tableHeader:i===0,cantSplit:true,children:row.map((text,j)=>new d.TableCell({
      width:{size:widths[j],type:d.WidthType.DXA},verticalAlign:d.VerticalAlign.CENTER,
      shading:{fill:i===0?'19334E':i%2?'FFFFFF':'F1F5F8'},margins:{top:65,bottom:65,left:100,right:100},
      children:[new d.Paragraph({spacing:{after:0,line:small?210:225},children:[new d.TextRun({text:String(text),font:'Times New Roman',size:small?18:20,bold:i===0,color:i===0?'FFFFFF':'000000'})]})]
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
const xmlEscape=s=>s.replace(/&/g,'&amp;').replace(/</g,'&lt;');
async function diagram(){
  const box=(x,y,w,h,lines)=>`<rect x="${x}" y="${y}" width="${w}" height="${h}" rx="6" fill="#f0f5f8" stroke="#19334e" stroke-width="2"/>${lines.map((s,i)=>`<text x="${x+w/2}" y="${y+26+i*21}" text-anchor="middle" font-family="Arial" font-size="17" fill="#19334e">${xmlEscape(s)}</text>`).join('')}`;
  const arrow=(a,b,c,e,label='')=>`<path d="M${a},${b} L${c},${e}" stroke="#41586d" stroke-width="2" fill="none" marker-end="url(#arrow)"/>${label?`<text x="${(a+c)/2+5}" y="${(b+e)/2-8}" font-family="Arial" font-size="14" fill="#41586d">${label}</text>`:''}`;
  const svg=`<svg xmlns="http://www.w3.org/2000/svg" width="1040" height="750" viewBox="0 0 1040 750"><rect width="1040" height="750" fill="white"/><defs><marker id="arrow" markerWidth="9" markerHeight="9" refX="8" refY="4.5" orient="auto"><path d="M0,0 L9,4.5 L0,9" fill="#41586d"/></marker></defs>
  ${box(30,20,400,78,['Human expert','Kushala Jayawickrama'])}${box(650,20,360,78,['Dental reference sources'])}
  ${box(335,148,370,78,['Knowledge acquisition','Source interpretation and review'])}
  ${arrow(230,98,400,148)}${arrow(830,98,640,148)}
  ${box(335,272,370,78,['Prolog knowledge base','30 domain facts and 25 rules'])}${arrow(520,226,520,272)}
  ${box(30,420,180,70,['Dentist'])}${box(270,415,340,78,['Java Swing interface','Consultation and knowledge viewing'])}
  ${arrow(210,440,270,440)}${arrow(270,475,210,475)}
  ${box(690,415,320,78,['JPL bridge','Structured terms'])}${arrow(610,440,690,440)}${arrow(690,475,610,475)}
  ${box(150,605,350,100,['Prolog adaptive routing','Applicable question identifiers'])}
  ${box(610,605,380,100,['SWI-Prolog inference engine','Validation and forward fixed point','Status candidates missing fields'])}
  <path d="M705,311 L1025,311 L1025,550 L970,550 L970,605" stroke="#41586d" stroke-width="2" fill="none" marker-end="url(#arrow)"/>
  ${arrow(850,493,850,605)}${arrow(900,605,900,493)}
  <path d="M740,493 L740,540 L325,540 L325,605" stroke="#41586d" stroke-width="2" fill="none" marker-end="url(#arrow)"/>
  <path d="M380,605 L380,570 L780,570 L780,493" stroke="#41586d" stroke-width="2" fill="none" marker-end="url(#arrow)"/>
  </svg>`;
  fs.writeFileSync(path.join(ROOT,'docs/report-assets/architecture.svg'),svg);
  await sharp(Buffer.from(svg),{density:180}).png().toFile(path.join(ROOT,'docs/report-assets/architecture.png'));
}
async function main(){
 await diagram();
 children.push(new d.Paragraph({text:'DentalExplain',style:'Title',spacing:{before:2300,after:280},alignment:d.AlignmentType.CENTER}));
 p('A Dental Diagnosis Expert System',{alignment:d.AlignmentType.CENTER,spacing:{after:1500},children:[new d.TextRun({text:'A Dental Diagnosis Expert System',size:32})]});
 for(const t of ['Vishwa Jayawickrama','CM3321','Logic Programming and Artificial Cognitive Systems','29 September 2026'])p(t,{alignment:d.AlignmentType.CENTER});
 p('Application 1.1.0   Knowledge 0.3.0',{alignment:d.AlignmentType.CENTER,spacing:{before:700,after:120}});
 const text=fs.readFileSync(path.join(ROOT,'docs/report.md'),'utf8');
 const tokens=require('marked').lexer(text);
 let contentsInserted=false;
 for(const t of tokens){
   if(t.type==='heading'){
     if(t.text==='1 Introduction'&&!contentsInserted){
       heading('Contents');
       const defaultPages={'Abstract':2,'1 Introduction':4,'2 Domain Definition and Scope':5,'3 Knowledge Acquisition':6,'4 Expert System Architecture':7,'5 Knowledge Representation':9,'6 Inference Method':10,'7 System Design and Implementation':11,'8 Testing and Evaluation':18,'9 Conclusion':19,'References':20,'Appendix A User Manual':21,'Appendix B Human Expert Questionnaire':24,'Appendix C Knowledge Catalogue':25,'Appendix D Acceptance Test Cases':28};
       const mapFile=path.join(ROOT,'build/report/page-map.json');
       const pageMap=fs.existsSync(mapFile)?JSON.parse(fs.readFileSync(mapFile,'utf8')):defaultPages;
       for(const [title,page] of Object.entries(pageMap))children.push(new d.Paragraph({tabStops:[{type:d.TabStopType.RIGHT,position:W,leader:d.LeaderType.DOT}],spacing:{after:155},children:[new d.TextRun(title+'\t'+page)]}));
       contentsInserted=true;
     }
     heading(t.text,t.depth);
   } else if(t.type==='paragraph'){
     const m=t.text.match(/^!\[([^\]]+)\]\(([^)]+)\)$/);
     if(m)picture(m[2],m[1]);else p(t.text.replace(/\[([^\]]+)\]\(([^)]+)\)/g,'$1 ($2)'));
   } else if(t.type==='table')table(t.header.map(c=>c.text),t.rows.map(r=>r.map(c=>c.text)));
   else if(t.type==='code'){
     for(const line of t.text.split('\n'))children.push(new d.Paragraph({spacing:{after:0,line:225},children:[new d.TextRun({text:line,font:'Courier New',size:18})]}));
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
   children.push(new d.Paragraph({keepNext:true,spacing:{before:80,after:45},children:[new d.TextRun({text:r.id.toUpperCase()+'   '+r.conclusion,bold:true,size:21})]}));
   p('IF '+r.premises.join(' AND ')+' THEN '+r.conclusion+'.',{children:runs('IF '+r.premises.join(' AND ')+' THEN '+r.conclusion+'.',{size:20}),keepNext:true,spacing:{after:35,line:220}});
   p('Source: '+r.source+'; review: pending.',{spacing:{after:65,line:200},style:'Caption'});
 }
 heading('Appendix D Acceptance Test Cases');
 p('All cases are synthetic. Software results below were reassessed from the source fixtures on 29 September 2026. Clinical expectations remain pending review. TC01-TC14 have diagnostic targets; TC15-TC20 are edge cases. Raw boundary fixtures may deliberately contain child fields hidden by the UI. The routed diagnostic checks independently exclude those fields and preserve each target.');
 p('The tables give every explicitly supplied fixture input. Any omitted question is Unknown, never No. Values are the stable Prolog identifiers from the controlled catalogue; checkbox lists identify selected items, while none records explicit absence. Invalid or contradictory fixtures are programmatic boundary tests, not combinations users can freely type into the interface.');
 heading('D.1 Question identifiers and display labels',2);
 table(['Identifier','Question','Stage'],data.questions.map(q=>[q.id,q.label,q.section==='setup'?'Setup':q.section==='symptoms'?'Step 1':'Step 2']),[2300,6060,1000],true);
 const titles=['Caries in a primary tooth','Caries in a permanent tooth in the child group','Caries in an adult permanent tooth','Reversible pulpitis in a primary tooth','Reversible pulpitis in an immature permanent tooth','Reversible pulpitis in a mature permanent tooth','Irreversible pulpitis candidate in a primary tooth','Irreversible pulpitis in an adolescent permanent tooth','Irreversible pulpitis in an adult permanent tooth','Gingivitis in mixed dentition','Gingivitis in adolescent permanent dentition','Gingivitis in the adult group','Periodontitis in the adult group','Periodontitis in the older-adult group','Missing age group','Invalid numeric age-group input','Missing required tooth information','Contradictory tooth-pain inputs','Jaw-only presentation outside scope','Blank consultation after reset'];
 const names={caries:'Dental caries',reversible_pulpitis:'Reversible pulpitis',irreversible_pulpitis:'Symptomatic irreversible pulpitis',gingivitis:'Gingivitis',periodontitis:'Periodontitis'};
 const statusNames={candidates:'Supported candidate conditions',incomplete:'Additional information needed',invalid:'Invalid input',conflict:'Conflicting inputs',outside_scope:'Outside supported scope'};
 data.cases.forEach((c,i)=>{
   children.push(new d.Paragraph({text:`D.${i+2} ${c.id.toUpperCase()} ${titles[i]}`,heading:d.HeadingLevel.HEADING_2,pageBreakBefore:true,keepNext:true,spacing:{after:140}}));
   if(i===19)p('Procedure: complete TC11 in the UI, choose New consultation, then assess the blank reset state. This fixture represents the resulting empty observation list; Java lifecycle tests separately verify that previous selections and results were cleared.');
   table(['Question identifier','Supplied value'],c.inputs.length?c.inputs.map(x=>[x.key,x.value]):[['All questions','Unknown after reset']],[3800,5560],true);
   const expected=c.target==='none'?statusNames[c.expected_status]:names[c.target]+' must be included; coexisting candidates permitted';
   p('Expected response: '+expected+'.',{keepNext:true,spacing:{after:80,line:240}});
   p('Actual response: '+statusNames[c.status]+'. Candidates: '+(c.candidates.length?c.candidates.map(x=>names[x]).join('; '):'none')+'.',{spacing:{after:80,line:240}});
   p('Missing requests: '+(c.missing.length?c.missing.join(', '):'none')+'.',{spacing:{after:80,line:240}});
   p('Message: '+c.messages.join(' '),{spacing:{after:80,line:240}});
   let prohibited=c.target==='none'?'Any supported candidate.':c.target==='caries'?'Unsupported pulpitis or periodontitis.':c.target==='reversible_pulpitis'?'Unsupported irreversible pulpitis or periodontitis.':c.target==='irreversible_pulpitis'?'Unsupported reversible pulpitis or periodontitis.':c.target==='gingivitis'?'Unsupported periodontitis or pulpitis.':'Unsupported intact-periodontium gingivitis or pulpitis.';
   p('Prohibited outcomes: '+prohibited,{spacing:{after:80,line:240}});
   p('Result: PASS software. Clinical review: pending.',{spacing:{after:80,line:240}});
   p('Source references: '+(i<3?'[1] and [3]':i<9?'[2] and [3]':i<12?'[4] and [6]':i<14?'[5]':'Implemented boundary and lifecycle requirements'),{style:'Caption'});
 });
 const doc=new d.Document({creator:'Vishwa Jayawickrama',title:'DentalExplain Report',description:'Dental diagnosis expert system report and user manual',
   styles:{default:{document:{run:{font:'Times New Roman',size:22,color:'000000'},paragraph:{spacing:{line:270,after:120}}}},paragraphStyles:[
     {id:'Title',name:'Title',basedOn:'Normal',run:{font:'Times New Roman',size:48,bold:true,color:'000000'}},
     {id:'Heading1',name:'Heading 1',basedOn:'Normal',next:'Normal',run:{size:30,bold:true,color:'000000'},paragraph:{outlineLevel:0}},
     {id:'Heading2',name:'Heading 2',basedOn:'Normal',next:'Normal',run:{size:24,bold:true,color:'000000'},paragraph:{outlineLevel:1}},
     {id:'Caption',name:'Caption',basedOn:'Normal',run:{size:19,color:'000000'},paragraph:{spacing:{after:120,line:225}}}
   ]},features:{updateFields:true},sections:[{properties:{page:{size:{width:11906,height:16838},margin:{top:1100,right:1273,bottom:1100,left:1273}}},footers:{default:new d.Footer({children:[new d.Paragraph({alignment:d.AlignmentType.CENTER,children:[new d.TextRun({children:[d.PageNumber.CURRENT],size:18})]})]})},children}]});
 fs.writeFileSync(path.join(OUT,'DentalExplain Report.docx'),await d.Packer.toBuffer(doc));
 console.log('Report authored with 30 facts, 25 rules, 20 executed cases and 7 figures.');
}
main().catch(e=>{console.error(e);process.exit(1)});
