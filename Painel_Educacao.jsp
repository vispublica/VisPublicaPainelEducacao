<html>
    <head>
        <title>Taxas de Rendimento Escolar na Educação Básica no Brasil</title>
        <script src="lib/jquery-1.7.2.min.js" type="text/javascript"></script>
        <script src="lib/jq-ui.min.js"></script>
        <link href="css/jq-ui.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="lib/highcharts.js"></script>
        <script type="text/javascript" src="http://code.highcharts.com/modules/exporting.js"></script>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
        <script type="text/javascript" src="lib/d3.v3.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="js/vispublica_PieChart.js"></script>
        <link href="css/vispublica_dashboard.css" rel="stylesheet" type="text/css" />
        <link href="css/style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <div class="container" style="min-height: 980px;">
            <div class="imageHeader">
                <img alt="Logo VisPublica" src="images/vp.png" width="70" class="imgHeader" style="float:left;" />
            </div>

            <br class="clear" />
            <div class="containerDashboardVisPublica">
                <div class="headerDashboard ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
                    <span class="ui-dialog-title" id="ui-id-1">Taxas de Rendimento Escolar na Educação Básica</span>
                    <a href="#1" onclick="javascript: openModalInfo();">
                        <span style="color: rgb(255, 255, 255);">Sobre o Painel</span>
                        <img src="images/icon_info.png">
                    </a>
                </div>
                <div class="parametros" style="float:left;">
                    <div class="mapWrapper">
                        <div class="mapTitle">Selecione o Estado:</div>
                        <%@include file="mapa.jsp" %>
                    </div>
                    <div class="optionsWrapper">
                        <form>
                            <div>
                                <span class="titulo">Ano:</span>
                                <select id="selectAnos" name="selectAnos" onchange="javascript:actionBttAtualizar(this.form);">
                                    <option selected >2011</option>
                                    <option >2010</option>
                                    <option >2009</option>
                                    <option >2008</option>
                                    <option >2007</option>                            
                                </select>
                            </div>

                            <div>
                                <span class="titulo">Redes:</span>
                                <select id="selectGrupo" name="selectGrupo" onchange="javascript:actionBttAtualizar(this.form);">
                                    <option selected value="Todos" >Todas</option>
                                    <option value="Part. / Publico" title="Particular e Público" >Part. / Público</option>
                                    <option value="Mun. / Fed. / Est." title="Municipal, Federal e Estadual" >Mun. / Fed. / Est.</option>
                                </select>
                            </div>

                            <div>
                                <span class="titulo">Taxa:</span>
                                <select id="selectTaxa" name="selectTaxa" onchange="javascript:actionBttAtualizar(this.form);">
                                    <option selected value="aprovacoes">Aprovação</option>
                                    <option value="reprovacoes" >Reprovação</option>
                                    <option value="abandonos" >Abandono</option>
                                </select>
                            </div>

                            <div>
                                <span class="titulo">Ensino:</span>
                                <table>
                                    <tr><td><input type="radio" checked="true" id="rbtEnsino" name="rbtEnsino" value="fundamental" onclick="javascript:actionBttAtualizar(this.form);"/></td><td>Fundamental</td></tr>
                                    <tr><td><input type="radio" id="rbtEnsino" name="rbtEnsino" value="medio" onclick="javascript:actionBttAtualizar(this.form);"/></td><td>Médio</td></tr>
                                </table>
                            </div>

                            <div>
                                <span class="titulo">Localidade:</span>
                                <table>
                                    <tr><td><input type="radio" checked="true" id="selectZona" name="selectZona" value="Urbana" onclick="javascript:actionBttAtualizar(this.form);" /></td><td>Zona Urbana</td></tr>
                                    <tr><td><input type="radio" id="selectZona" name="selectZona" value="Rural" onclick="javascript:actionBttAtualizar(this.form);"/></td><td>Zona Rural</td></tr>
                                    <tr><td><input type="radio" id="selectZona" name="selectZona" value="Total" onclick="javascript:actionBttAtualizar(this.form);"/></td><td>Rural e Urbana</td></tr>
                                </table>
                                <input type="hidden" id="inputTitulo" />
                            </div>

                        </form>
                    </div>

                </div>
                <div class="pieWrapper">
                    <div class="wrapperTitle"></div>
                </div>
                <div class="columnWrapper" id="columnWrapper"></div>
            </div>
            <script>
                dadosDashboard = new Object();                
                actionClickMap(pathSP);
                
            
                function carregaDados(dataD){
                    dadosDashboard = dataD;
                }
            
                function loadBarChart(container, ano, titulo, local, etapa, grupo, taxa){
                
                    var serie = dadosDashboard[ano].locais[local];
                
                    var descTaxa;
                    var descEtapa;
                    var catEtapa = new Array();
                    var dataEtapa;
                    // TODO VER GRUPO
                    var d = new Array();
                    var max = 0;
            
                    for(var r in serie.redes){
                        dataEtapa = serie.redes[r][taxa].slice(0,0+9);
                        if(etapa.toLowerCase() == "medio"){
                            dataEtapa = serie.redes[r][taxa].slice(10,14);
                        }
                        if(r == "Total"){
                            d.push({
                                type: 'spline',
                                color: '#FF6E00',
                                name: r,
                                data: dataEtapa,
                                marker: {
                                    lineWidth: 2,
                                    lineColor: '#FF6E00',
                                    fillColor: 'white'
                                }
                            });
                        }
                
                        if(grupo == "Todos"){
                            if(r != "Total"){
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }
                            
                        } else if (grupo == "Part. / Publico"){
                            if (r == "Particular" || r == "Publico"){
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }
                        
                        } else if (grupo == "Mun. / Fed. / Est."){
                            if (r == "Estadual" || r == "Federal" || r == "Municipal"){
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }
                        }

                        if(etapa.toLowerCase() == "fundamental"){
                            if(d3.max(serie.redes[r][taxa].slice(0,0+9))>max){
                                max = d3.max(serie.redes[r][taxa].slice(0,0+9));
                            }
                        } else {
                            if(d3.max(serie.redes[r][taxa].slice(10,14))>max){
                                max = d3.max(serie.redes[r][taxa].slice(10,14));
                            }
                        }
                    }
                
                    if(taxa=="aprovacoes"){
                        descTaxa = "Aprovação";
                        max = 100;
                    }else if(taxa == "reprovacoes"){
                        descTaxa = "Reprovação";
                    }else{
                        descTaxa = "Abandono";
                    }


                    if(etapa.toLowerCase()=="medio"){
                        descEtapa = "Médio";
                        catEtapa.push("1ª Série","2ª Série","3ª Série","4ª Série");
                    } else {
                        descEtapa = "Fundamental";
                        catEtapa.push("1º Ano","2º Ano","3º Ano","4º Ano","5º Ano","6º Ano","7º Ano","8º Ano","9º Ano");
                    }
                
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: container,
                            backgroundColor: '#FFF'
                        },
    
                        title: {
                            text: descTaxa+' no Ensino '+descEtapa+' na Zona '+((local=="Total")?"Urbana/Rural":local)+' ('+titulo+'/'+ano+')'
                        },
                        
                        exporting: {
                            enabled: false
                        },
    
                        xAxis: {
                            categories: catEtapa
                        },
    
                        yAxis: {
                            allowDecimals: true,
                            min: 0,
                            max: max,
                            title: {
                                text: 'Taxa de '+descTaxa+' (%)'
                            }
                        },
                    
                        // TODO REVER TOOLTIP
                        tooltip: {
                            formatter: function() {
                                return '<b>'+ this.x +'</b><br/>'+
                                    this.series.name +': '+ this.y + '%';
                            }
                        },
    
                        series: d
                    });
                   

                }
                
                function loadData(dataPath, titulo){
                
                    d3.csv(dataPath, function(error, data) {
                    
                        var nest = d3.nest()
                        .key(function(d) { return d.Ano; })
                        .sortKeys(d3.descending)
                        .key(function(d) { return d.Local; })
                        .key(function(d) { return d.Rede; })
                        .sortKeys(d3.ascending)
                        .entries(data);
                    
                        var dados = new Object();
                        for(i=0;i<nest.length;i++){
                            var dado = {ano: nest[i].key};
                            dado.locais = new Object();
                            
                            for(j=0;j<nest[i].values.length;j++){
                                var local = {local: nest[i].values[j].key};
                                local.redes= new Object();
                            
                                for(k=0;k<nest[i].values[j].values.length;k++){
                                    var rede = {rede: nest[i].values[j].values[k].key};
                                    
                                    var ins = nest[i].values[j].values[k].values[0];
                                    
                                    rede.aprovacoes = new Object();
                                    rede.aprovacoes = [
                                        parseFloat(ins.Aprov_1ano_Fund), parseFloat(ins.Aprov_2ano_Fund), parseFloat(ins.Aprov_3ano_Fund), parseFloat(ins.Aprov_4ano_Fund), parseFloat(ins.Aprov_5ano_Fund), parseFloat(ins.Aprov_6ano_Fund), parseFloat(ins.Aprov_7ano_Fund), parseFloat(ins.Aprov_8ano_Fund), parseFloat(ins.Aprov_9ano_Fund),
                                        parseFloat(ins.Aprov_1serie_Medio), parseFloat(ins.Aprov_2serie_Medio), parseFloat(ins.Aprov_3serie_Medio), parseFloat(ins.Aprov_4serie_Medio),
                                        parseFloat(ins.Total_Aprov_Fund), parseFloat(ins.Total_Aprov_Medio)
                                    ];
                                        
                                    rede.reprovacoes = new Object();
                                    rede.reprovacoes = [
                                        parseFloat(ins.Reprov_1ano_Fund), parseFloat(ins.Reprov_2ano_Fund), parseFloat(ins.Reprov_3ano_Fund), parseFloat(ins.Reprov_4ano_Fund), parseFloat(ins.Reprov_5ano_Fund), parseFloat(ins.Reprov_6ano_Fund), parseFloat(ins.Reprov_7ano_Fund), parseFloat(ins.Reprov_8ano_Fund), parseFloat(ins.Reprov_9ano_Fund),
                                        parseFloat(ins.Reprov_1serie_Medio), parseFloat(ins.Reprov_2serie_Medio), parseFloat(ins.Reprov_3serie_Medio), parseFloat(ins.Reprov_4serie_Medio),
                                        parseFloat(ins.Total_Reprov_Fund), parseFloat(ins.Total_Reprov_Medio)
                                    ];
                                        
                                    rede.abandonos = new Object();
                                    rede.abandonos = [
                                        parseFloat(ins.Abandono_1ano_Fund), parseFloat(ins.Abandono_2ano_Fund), parseFloat(ins.Abandono_3ano_Fund), parseFloat(ins.Abandono_4ano_Fund), parseFloat(ins.Abandono_5ano_Fund), parseFloat(ins.Abandono_6ano_Fund), parseFloat(ins.Abandono_7ano_Fund), parseFloat(ins.Abandono_8ano_Fund), parseFloat(ins.Abandono_9ano_Fund),
                                        parseFloat(ins.Abandono_1serie_Medio), parseFloat(ins.Abandono_2serie_Medio), parseFloat(ins.Abandono_3serie_Medio), parseFloat(ins.Abandono_4serie_Medio),
                                        parseFloat(ins.Total_Abandono_Fund), parseFloat(ins.Total_Abandono_Medio)
                                    ];
                                    
                                    
                                    local.redes[nest[i].values[j].values[k].key] = rede;
                                }
                                dado.locais[nest[i].values[j].key] = local;
                            }
                            dados[nest[i].key] = dado;
                        }
                    
                    
                        /*$("#selectAnos option").remove();
                        for(i=0;i<nest.length;i++){
                            $("#selectAnos").append("<option>"+nest[i].key+"</option>");
                        }*/
                    
                        $("#inputTitulo").attr("value", titulo);

                        var selAnos = document.getElementById('selectAnos');
                        var selGrupo = document.getElementById('selectGrupo');
                        var selTaxa = document.getElementById('selectTaxa');
                    
                        /*selGrupo.selectedIndex = 0;
                        selTaxa.selectedIndex = 0;
                        selZona.selectedIndex = 0;
                        selEnsino.checked  = true;*/
                    
                        this.carregaDados(dados);
                    
                        //this.updateDataPieChart(nest[0].key, titulo, "Urbana", "fundamental", "Todos");
                        this.updateDataPieChart(selAnos.options[selAnos.selectedIndex].text,
                        titulo,
                        $('input#selectZona:checked').val(),
                        $('input[@name="rbtEnsino"]:checked').val(),
                        selGrupo.options[selGrupo.selectedIndex].value);
                    
                        setTimeout(function(){
                            this.loadBarChart("columnWrapper", selAnos.options[selAnos.selectedIndex].text,
                            titulo,
                            $('input#selectZona:checked').val(),
                            $('input[@name="rbtEnsino"]:checked').val(),
                            selGrupo.options[selGrupo.selectedIndex].value,
                            selTaxa.options[selTaxa.selectedIndex].value);
                        }, 500);
                
                        //initBarChart(dados);
                    });

                }
                
                function actionClickMap(e){
                    d3.select(".estadoClicked").classed("estadoClicked",false); 
                    d3.select("path#"+e.id).classed("estadoClicked",true); 
                }
            
                function actionBttAtualizar(formDados){
                
                    updateDashboard(formDados.selectAnos.value,
                    formDados.inputTitulo.value,
                    $('input#selectZona:checked').val(),
                    $('input[@name="rbtEnsino"]:checked').val(),
                    formDados.selectGrupo.value,
                    formDados.selectTaxa.value);
                }
            
                function updateDashboard(ano, titulo, local, etapa, grupo, taxa){
                    updateDataPieChart(ano, titulo, local, etapa, grupo);

                    setTimeout(function(){
                        loadBarChart("columnWrapper", ano, titulo, local, etapa, grupo, taxa);
                    },500);
                }
                
                function openModalInfo(){
                    $("#modalInfoDashboard").dialog("open");
                }
            
                $(function () {
                    var chart;
                    $(document).ready(function() {
                        initPieChart("pieWrapper");
                        loadData("Csv_Estados/SP_Rendimento.csv", "São Paulo"); /*LOAD DATA BRASIL*/
                        $("#modalInfoDashboard").dialog({
                            width: 620,
                            resizable: false,
                            autoOpen: false,
                            modal:true
                        });
                    });
                });
            </script>
            <div class="creativeCommons" id="creativeCommons">
                <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank"><img alt="Licença Creative Commons" style="border-width:0" src="http://i.creativecommons.org/l/by-nc/3.0/br/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">Este trabalho</span> está licenciado sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank">licença Creative Commons Atribuição-NãoComercial 3.0 Brasil</a>.
            </div>

    </body>
    <div id="modalInfoDashboard" class="modalInfoDashboard" title="Sobre o Painel">
        <p>O objetivo do painel é apresentar de forma gráfica e interativa as taxas de rendimento escolar da educação básica no Brasil nos anos de 2007 a 2011.</p>
        <p>O painel permite analisar o percentual do rendimento das taxas de aprovação, reprovação e abandono de todos os estados brasileiros. Além disso, é possível visualizar as taxas por rede (pública, privada, municipal, estadual e federal), por ensino (fundamental e médio) e por localidade (zona rural e urbana).</p>
        <p>O painel foi desenvolvido no contexto do projeto VisPublica (Visualização de Dados Públicos) através de uma parceria entre a COPPE/UFRJ, a UNIFEI (Universidade Federal de Itajubá) e o Ministério do Planejamento, Orçamento e Gestão.</p>
        <p>O objetivo do projeto é investigar as técnicas de Visualização de Informação e sua aplicação no contexto governamental.</p>
        <p>Para o desenvolvimento do painel foram utilizadas as seguintes técnicas e tecnologias:</p>
        <ul>
            <li>O Mapa foi construído com a tecnologia SVG (Scalable Vector Graphics - Gráficos Vetoriais Escaláveis)</li>
            <li>O Gráfico de Pizza foi gerado com a tecnologia D3 (Data-Driven Documents)</li>
            <li>Para a elaboração do Gráfico de Barras foi utilizado a tecnologia Highcharts</li>
        </ul>
        <p>Os dados apresentados estão disponíveis no Portal Brasileiro de Dados Abertos através do link abaixo:</p>
        <p>Taxas de Rendimento Escolar na Educação Básica:<br><a href="http://dados.gov.br/dataset/taxas-de-rendimento-escolar-na-educacao-basica" target="_blank">http://dados.gov.br/dataset/taxas-de-rendimento-escolar-na-educacao-basica</a></p>
        <p>O código fonte do painel esta disponível em: <br><a href="https://github.com/vispublica/VisPublicaPainelEducacao.git" target="_blank">https://github.com/vispublica/VisPublicaPainelEducacao.git</a></p>
        <p>Para saber mais sobre o projeto VisPublica e as técnicas e tecnologias utilizadas no painel, acesse portal <a href="http://vispublica.gov.br/" target="_blank">VisPublica</a></p>
    </div>
</html>
