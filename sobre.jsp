<%@ page isELIgnored="false" contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="vTemplate" tagdir="/WEB-INF/tags/template" %>

<vTemplate:basic>
    <jsp:attribute name="head">
        <link href="/vispublica/css/style.css" rel="stylesheet" type="text/css" />
        <title>Sobre o Painel Educação</title>
    </jsp:attribute>
    <jsp:attribute name="content">
        <div class="sobre">
            <div class="headerSobre">
        <span class="titleSobre">Informações do Painel Educação</span>
            </div>
            <div class="contentSobre">
        <p>O objetivo do painel é apresentar de forma gráfica e interativa as taxas de rendimento escolar da educação básica no Brasil nos anos de 2007 a 2011.</p><br/>
        <p>O painel permite analisar o percentual do rendimento das taxas de aprovação, reprovação e abandono de todos os estados brasileiros. Além disso, é possível visualizar as taxas por rede (pública, privada, municipal, estadual e federal), por ensino (fundamental e médio) e por localidade (zona rural e urbana).</p>
        <p>O painel foi desenvolvido no contexto do projeto VisPublica (Visualização de Dados Públicos) através de uma parceria entre a COPPE/UFRJ, a UNIFEI (Universidade Federal de Itajubá) e o Ministério do Planejamento, Orçamento e Gestão.</p><br/>
        <p>O objetivo do projeto é investigar as técnicas de Visualização de Informação e sua aplicação no contexto governamental.</p><br/>
        <p>Para o desenvolvimento do painel foram utilizadas as seguintes técnicas e tecnologias:</p>
        <ul>
            <li>O Mapa foi construído com a tecnologia SVG (Scalable Vector Graphics - Gráficos Vetoriais Escaláveis)</li>
            <li>O Gráfico de Pizza foi gerado com a tecnologia D3 (Data-Driven Documents)</li>
            <li>Para a elaboração do Gráfico de Barras foi utilizado a tecnologia Highcharts</li>
        </ul>
        <p><b>Os dados apresentados estão disponíveis no Portal Brasileiro de Dados Abertos através do link abaixo.</b></p><br/>
        <p>Taxas de Rendimento Escolar na Educação Básica:<br><a href="http://dados.gov.br/dataset/taxas-de-rendimento-escolar-na-educacao-basica" target="_blank">http://dados.gov.br/dataset/taxas-de-rendimento-escolar-na-educacao-basica</a></p><br/>
        <p><b>O código fonte do painel está disponível em: </b><br><a href="https://github.com/vispublica/VisPublicaPainelEducacao.git" target="_blank">https://github.com/vispublica/VisPublicaPainelEducacao.git</a></p><br/>
        <p>Para saber mais sobre o projeto VisPublica e as técnicas e tecnologias utilizadas no painel, acesse portal <a href="http://vispublica.gov.br/" target="_blank">VisPublica</a></p><br/>
         </div>
        </div>
         </jsp:attribute>
</vTemplate:basic>
