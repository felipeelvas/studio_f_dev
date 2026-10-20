from pathlib import Path
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
import pypdfium2 as pdfium

root=Path(__file__).resolve().parents[2]
out=root/'output/pdf/curriculo_Felipe_Elvas_TI.pdf'
out.parent.mkdir(parents=True,exist_ok=True)
styles={
 'name':ParagraphStyle('name',fontName='Helvetica-Bold',fontSize=20,leading=24,textColor=colors.HexColor('#17324D'),spaceAfter=5),
 'title':ParagraphStyle('title',fontName='Helvetica-Bold',fontSize=10.5,leading=14,spaceAfter=7),
 'body':ParagraphStyle('body',fontName='Helvetica',fontSize=9.5,leading=13,spaceAfter=4),
 'section':ParagraphStyle('section',fontName='Helvetica-Bold',fontSize=10.5,leading=14,textColor=colors.HexColor('#17324D'),spaceBefore=10,spaceAfter=5),
}
story=[]
def p(text,style='body'):story.append(Paragraph(text,styles[style]))
p('Felipe Elvas Barbosa','name')
p('DESENVOLVEDOR JÚNIOR | MOBILE E WEB','title')
p('Brasília / Samambaia, DF | (61) 99813-8835 | felipeelvas@gmail.com')
p('<link href="https://github.com/felipeelvas">github.com/felipeelvas</link> | <link href="https://www.linkedin.com/in/felipe-elvas">linkedin.com/in/felipe-elvas</link>')
p('RESUMO PROFISSIONAL','section')
p('Desenvolvedor em início de carreira, com experiência de estágio em desenvolvimento de software e foco em Flutter e Dart. Prática em aplicações mobile e web, integração com APIs, interfaces e bancos de dados SQL. Atualmente desenvolve um site para salão de beleza e um aplicativo, consolidando conhecimentos por meio de projetos e estudos. Busca oportunidade júnior em TI, com interesse em desenvolvimento mobile e frontend.')
p('CONHECIMENTOS TÉCNICOS','section')
p('<b>Foco principal:</b> Dart e Flutter. <b>Linguagens e fundamentos web:</b> Java, JavaScript, TypeScript, HTML e CSS.')
p('<b>Frameworks e bibliotecas:</b> Angular, Spring Boot e estudos em React. <b>Bancos de dados:</b> PostgreSQL e MySQL.')
p('<b>Ferramentas e práticas:</b> Git/GitHub, integração frontend-backend, internacionalização, interfaces e componentes reutilizáveis; testes com flutter_test e mockito.')
p('EXPERIÊNCIA EM TECNOLOGIA','section')
p('<b>Facilite S/A | Estagiário em Desenvolvimento de Software</b><br/>Brasília, DF | 2023 - 2025')
for item in [
'Participação no desenvolvimento e manutenção de aplicações com Flutter, Angular e Spring Boot.',
'Contribuição em funcionalidades financeiras e integração de extratos bancários nos formatos OFX e CSV da Wise.',
'Apoio à integração entre frontend e backend em rotinas de cadastros, autenticação e funcionalidades financeiras.',
'Melhorias de interfaces, navegação, filtros e componentes; suporte multilíngue e testes unitários com flutter_test e mockito.'
]:p('• '+item)
p('PROJETOS E ESTUDOS ATUAIS','section')
p('<b>Site para salão de beleza | Em desenvolvimento</b><br/>Projeto web voltado à apresentação do negócio, com prática em construção de interfaces e organização do conteúdo.')
p('<b>Aplicativo | Em desenvolvimento</b><br/>Projeto pessoal para aprofundar conhecimentos em desenvolvimento mobile com foco nos estudos de Flutter e Dart.')
p('<b>Desafio IMC | Flutter e Dart</b><br/>Aplicativo de cálculo de IMC com histórico, animações e persistência local com Hive.<br/><link href="https://github.com/felipeelvas/desafio_imc">github.com/felipeelvas/desafio_imc</link>')
p('<b>Blog fullstack | Angular e Spring Boot (Java)</b><br/>Projeto com frontend e backend integrados, voltado à prática de desenvolvimento web e organização de código.')
p('FORMAÇÃO ACADÊMICA','section')
p('<b>Bacharelado em Sistemas de Informação</b> | Descomplica Faculdade Digital | 2022 - 2025')
p('<b>Tecnólogo em Gestão de Recursos Humanos</b> | Anhanguera Educacional | 2018 - 2020')
p('FORMAÇÃO COMPLEMENTAR E COMUNIDADE','section')
p('<b>DIO:</b> bootcamps e desafios desde 2022 em programação, Git/GitHub, desenvolvimento mobile e web. Participação no DIO Campus Expert e atuação como Embaixador DIO, com aprendizado em colaboração, liderança e networking.')
doc=SimpleDocTemplate(str(out),pagesize=(595.28,841.89),rightMargin=38,leftMargin=38,topMargin=30,bottomMargin=30,title='Felipe Elvas Barbosa - Currículo TI',author='Felipe Elvas Barbosa')
doc.build(story)
pdf=pdfium.PdfDocument(str(out))
print('Pages:',len(pdf))
for i,page in enumerate(pdf):
 page.render(scale=1.5).to_pil().save(root/f'tmp/pdfs/resume_page_{i+1}.png')
print(out)
