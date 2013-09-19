<%@ page isELIgnored="false" contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="vTemplate" tagdir="/WEB-INF/tags/template" %>

<vTemplate:basic>
    <jsp:attribute name="head">
        <title>Taxas de Rendimento Escolar na Educação Básica no Brasil</title>
        <script src="/vispublica/js/jq-ui.min.js"></script>
        <link href="/vispublica/css/jq-ui.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="/vispublica/js/highcharts/highcharts.js"></script>
        <script type="text/javascript" src="http://code.highcharts.com/modules/exporting.js"></script>
        <meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />
        <script type="text/javascript" src="/vispublica/js/d3.v3.min.js"></script>
        <script type="text/javascript" charset="utf-8" src="vispublica_PieChart.js"></script>
        <link href="/vispublica/css/dashboard.css" rel="stylesheet" type="text/css" />
        <link href="vispublica_dashboard.css" rel="stylesheet" type="text/css" />
    </jsp:attribute>
    <jsp:attribute name="content">
        <br class="clear" />
        <div class="containerDashboardVisPublica painelEducacaoDashboard">
            <div class="headerDashboard">
                <span class="titleDashboard">Taxas de Rendimento Escolar na Educação Básica</span>
                <a href="/vispublica/publico/integracao/dadosgov/aplicativo/sobre.jsp" target="_blank">
                    <span>Sobre o projeto</span>
                    <img src="/vispublica/images/icon_info.png">
                </a>
            </div>
            <div id="url" class="url">
                <div class="urlText">Para compartilhar o painel, copie a url abaixo:</div>
                <input type="text" name="inputUrl" id="inputUrl" class="text ui-widget-content ui-corner-all inputUrlLabel">
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
                                <option selected value="2011" >2011</option>
                                <option value="2010" >2010</option>
                                <option value="2009" >2009</option>
                                <option value="2008" >2008</option>
                                <option value="2007" >2007</option>
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

            <script>
                dadosDashboard = new Object();

                document.getElementById('containerBarVisPublicaPage').style.display = 'none';

                function carregaDados(dataD) {
                    dadosDashboard = dataD;
                }

                var mapaLoadData = [];
                mapaLoadData['pathAC'] = {arq: "Csv_Estados/AC_Rendimento.csv", title: "Acre"};
                mapaLoadData['pathRO'] = {arq: "Csv_Estados/RO_Rendimento.csv", title: "Rondônia"};
                mapaLoadData['pathAM'] = {arq: "Csv_Estados/AM_Rendimento.csv", title: "Amazonas"};
                mapaLoadData['pathRR'] = {arq: "Csv_Estados/RR_Rendimento.csv", title: "Roraima"};
                mapaLoadData['pathAP'] = {arq: "Csv_Estados/AP_Rendimento.csv", title: "Amapá"};
                mapaLoadData['pathTO'] = {arq: "Csv_Estados/TO_Rendimento.csv", title: "Tocantins"};
                mapaLoadData['pathMT'] = {arq: "Csv_Estados/MT_Rendimento.csv", title: "Mato Grosso"};
                mapaLoadData['pathGO'] = {arq: "Csv_Estados/GO_Rendimento.csv", title: "Goiás"};
                mapaLoadData['pathMS'] = {arq: "Csv_Estados/MS_Rendimento.csv", title: "Mato Grosso do Sul"};
                mapaLoadData['pathMG'] = {arq: "Csv_Estados/MG_Rendimento.csv", title: "Minas Gerais"};
                mapaLoadData['pathPR'] = {arq: "Csv_Estados/PR_Rendimento.csv", title: "Paraná"};
                mapaLoadData['pathRS'] = {arq: "Csv_Estados/RS_Rendimento.csv", title: "Rio Grande do Sul"};
                mapaLoadData['pathBA'] = {arq: "Csv_Estados/BA_Rendimento.csv", title: "Bahia"};
                mapaLoadData['pathPI'] = {arq: "Csv_Estados/PI_Rendimento.csv", title: "Piauí"};
                mapaLoadData['pathCE'] = {arq: "Csv_Estados/CE_Rendimento.csv", title: "Ceará"};
                mapaLoadData['pathRN'] = {arq: "Csv_Estados/RN_Rendimento.csv", title: "Rio Grande do Norte"};
                mapaLoadData['pathAL'] = {arq: "Csv_Estados/AL_Rendimento.csv", title: "Alagoas"};
                mapaLoadData['pathSE'] = {arq: "Csv_Estados/SE_Rendimento.csv", title: "Sergipe"};
                mapaLoadData['pathDF'] = {arq: "Csv_Estados/DF_Rendimento.csv", title: "Distrito Federal"};
                mapaLoadData['pathPE'] = {arq: "Csv_Estados/PE_Rendimento.csv", title: "Pernambuco"};
                mapaLoadData['pathMA'] = {arq: "Csv_Estados/MA_Rendimento.csv", title: "Maranhão"};
                mapaLoadData['pathPA'] = {arq: "Csv_Estados/PA_Rendimento.csv", title: "Pará"};
                mapaLoadData['pathSP'] = {arq: "Csv_Estados/SP_Rendimento.csv", title: "São Paulo"};
                mapaLoadData['pathRJ'] = {arq: "Csv_Estados/RJ_Rendimento.csv", title: "Rio de Janeiro"};
                mapaLoadData['pathES'] = {arq: "Csv_Estados/ES_Rendimento.csv", title: "Espírito Santo"};
                mapaLoadData['pathSC'] = {arq: "Csv_Estados/SC_Rendimento.csv", title: "Santa Catarina"};
                mapaLoadData['pathPB'] = {arq: "Csv_Estados/PB_Rendimento.csv", title: "Paraíba"};

                url = {
                    uf: '',
                    ano: '',
                    redes: '',
                    taxa: '',
                    ensino: '',
                    local: ''
                };

                //etapa = ensino
                //grupo = redes


                function loadBarChart(container, ano, titulo, local, etapa, grupo, taxa) {

                    var serie = dadosDashboard[ano].locais[local];

                    var descTaxa;
                    var descEtapa;
                    var catEtapa = new Array();
                    var dataEtapa;
                    // TODO VER GRUPO
                    var d = new Array();
                    var max = 0;

                    for (var r in serie.redes) {
                        dataEtapa = serie.redes[r][taxa].slice(0, 0 + 9);
                        if (etapa.toLowerCase() == "medio") {
                            dataEtapa = serie.redes[r][taxa].slice(10, 14);
                        }
                        if (r == "Total") {
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

                        if (grupo == "Todos") {
                            if (r != "Total") {
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }

                        } else if (grupo == "Part. / Publico") {
                            if (r == "Particular" || r == "Publico") {
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }

                        } else if (grupo == "Mun. / Fed. / Est.") {
                            if (r == "Estadual" || r == "Federal" || r == "Municipal") {
                                d.push({
                                    type: 'column',
                                    name: r,
                                    data: dataEtapa
                                });
                            }
                        }

                        if (etapa.toLowerCase() == "fundamental") {
                            if (d3.max(serie.redes[r][taxa].slice(0, 0 + 9)) > max) {
                                max = d3.max(serie.redes[r][taxa].slice(0, 0 + 9));
                            }
                        } else {
                            if (d3.max(serie.redes[r][taxa].slice(10, 14)) > max) {
                                max = d3.max(serie.redes[r][taxa].slice(10, 14));
                            }
                        }
                    }

                    if (taxa == "aprovacoes") {
                        descTaxa = "Aprovação";
                        max = 100;
                    } else if (taxa == "reprovacoes") {
                        descTaxa = "Reprovação";
                    } else {
                        descTaxa = "Abandono";
                    }


                    if (etapa.toLowerCase() == "medio") {
                        descEtapa = "Médio";
                        catEtapa.push("1ª Série", "2ª Série", "3ª Série", "4ª Série");
                    } else {
                        descEtapa = "Fundamental";
                        catEtapa.push("1º Ano", "2º Ano", "3º Ano", "4º Ano", "5º Ano", "6º Ano", "7º Ano", "8º Ano", "9º Ano");
                    }

                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: container,
                            backgroundColor: '#FFF'
                        },
                        title: {
                            text: descTaxa + ' no Ensino ' + descEtapa + ' na Zona ' + ((local == "Total") ? "Urbana/Rural" : local) + ' (' + titulo + '/' + ano + ')'
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
                                text: 'Taxa de ' + descTaxa + ' (%)'
                            }
                        },
                        // TODO REVER TOOLTIP
                        tooltip: {
                            formatter: function() {
                                return '<b>' + this.x + '</b><br/>' +
                                    this.series.name + ': ' + this.y + '%';
                            }
                        },
                        series: d
                    });


                }

                function loadData(dataPath, titulo) {

                    d3.csv(dataPath, function(error, data) {

                        var nest = d3.nest()
                        .key(function(d) {
                            return d.Ano;
                        })
                        .sortKeys(d3.descending)
                        .key(function(d) {
                            return d.Local;
                        })
                        .key(function(d) {
                            return d.Rede;
                        })
                        .sortKeys(d3.ascending)
                        .entries(data);

                        var dados = new Object();
                        for (i = 0; i < nest.length; i++) {
                            var dado = {ano: nest[i].key};
                            dado.locais = new Object();

                            for (j = 0; j < nest[i].values.length; j++) {
                                var local = {local: nest[i].values[j].key};
                                local.redes = new Object();

                                for (k = 0; k < nest[i].values[j].values.length; k++) {
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

                        setTimeout(function() {
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

                function actionClickMap(e) {

                    d3.select(".estadoClicked").classed("estadoClicked", false);
                    d3.select("path#" + e.id).classed("estadoClicked", true);
                    url.uf = e.id;
                    document.getElementById('inputUrl').value = montaUrl();

                }

                function actionBttAtualizar(formDados) {

                    updateDashboard(formDados.selectAnos.value,
                    formDados.inputTitulo.value,
                    $('input#selectZona:checked').val(),
                    $('input[@name="rbtEnsino"]:checked').val(),
                    formDados.selectGrupo.value,
                    formDados.selectTaxa.value);
                }

                function updateDashboard(ano, titulo, local, etapa, grupo, taxa) {
                    updateDataPieChart(ano, titulo, local, etapa, grupo);

                    url.ano = ano;
                    url.redes = grupo;
                    url.taxa = taxa;
                    url.ensino = etapa;
                    url.local = local;

                    document.getElementById('inputUrl').value = montaUrl();


                    setTimeout(function() {
                        loadBarChart("columnWrapper", ano, titulo, local, etapa, grupo, taxa);
                    }, 500);
                }

                $(function(){
                    $('#modalInfoLink').click(function(e){
                        e.preventDefault();

                        var left  = ($(window).width()-500)/2,
                        top   = ($(window).height()-400)/2,
                        popup = window.open("sobre.jsp", "popup", "width=500,height=600, top="+top+", left="+left);

                        return false;
                    });
                })

                function montaUrl() {
                    var textUrl = window.location.href.split("?")[0];

                    if (url.uf == '' || url.uf == null) {
                        textUrl += '?uf=pathSP';
                    } else {
                        textUrl += '?uf=' + url.uf;
                    }
                    if (url.ano == '' || url.ano == null) {
                        textUrl += '&ano=2011';
                    } else {
                        textUrl += '&ano=' + url.ano;
                    }
                    if (url.redes == '' || url.redes == null) {
                        textUrl += '&redes=Todos';
                    } else {
                        textUrl += '&redes=' + url.redes;
                    }
                    if (url.taxa == '' || url.taxa == null) {
                        textUrl += '&taxa=aprovacoes';
                    } else {
                        textUrl += '&taxa=' + url.taxa;
                    }
                    if (url.ensino == '' || url.ensino == null) {
                        textUrl += '&ensino=fundamental';
                    } else {
                        textUrl += '&ensino=' + url.ensino;
                    }
                    if (url.local == '' || url.local == null) {
                        textUrl += '&local=Urbana';
                    } else {
                        textUrl += '&local=' + url.local;
                    }
                    return textUrl;
                }
                    

                function getParameterUrl(name) {
                    var url = window.location.search.replace("?", "");
                    var itens = url.split("&");

                    for (var n in itens) {
                        if (itens[n].match(name)) {
                            return decodeURIComponent(itens[n].replace(name + "=", ""));
                        }
                    }
                    return null;
                }


                function urlToJs() {
                    if (getParameterUrl('uf') != null) {
                        url.uf = getParameterUrl('uf');
                    }
                    if (getParameterUrl('ano') != null) {
                        url.ano = getParameterUrl('ano');
                    }
                    if (getParameterUrl('redes') != null) {
                        url.redes = getParameterUrl('redes');
                    }
                    if (getParameterUrl('taxa') != null) {
                        url.taxa = getParameterUrl('taxa');
                    }
                    if (getParameterUrl('ensino') != null) {
                        url.ensino = getParameterUrl('ensino');
                    }
                    if (getParameterUrl('local') != null) {
                        url.local = getParameterUrl('local');
                    }

                }

                function montaPainelUrl() {

                    if (url.uf == "") {
                        loadData("Csv_Estados/SP_Rendimento.csv", "São Paulo"); /*LOAD DATA BRASIL*/
                        actionClickMap(pathSP);
                    } else {
                        d3.select("path#" + url.uf).classed("estadoClicked", true);
                        loadData(mapaLoadData[url.uf].arq, mapaLoadData[url.uf].title);
                    }
                    if (url.ano != "") {
                        $('#selectAnos').select('option').val(url.ano);
                    }
                    if (url.redes != "") {
                        $('#selectGrupo').select('option').val(url.redes);
                    }
                    if (url.taxa != "") {
                        $('#selectTaxa').select('option').val(url.taxa);
                    }
                    if (url.ensino != "") {
                        if (url.ensino == "medio") {
                            $('input:radio[name=rbtEnsino]')[1].checked = true;
                        } else {
                            $('input:radio[name=rbtEnsino]')[0].checked = true;
                        }
                    }
                    if (url.local != "") {
                        if (url.local == "Urbana") {
                            $('input:radio[name=selectZona]')[0].checked = true;
                        } else if (url.local == "Rural") {
                            $('input:radio[name=selectZona]')[1].checked = true;
                        } else {
                            $('input:radio[name=selectZona]')[2].checked = true;
                        }
                    }
                }

                $(function() {
                    var chart;
                    $(document).ready(function() {
                        initPieChart("pieWrapper");

                        $("#modalInfoDashboard").dialog({
                            width: 620,
                            resizable: false,
                            autoOpen: false,
                            modal: true
                        });

                        //Captura as parametros da Url e mapeia para uma estrutura js
                        urlToJs();
                        //inicia o painel com os parametros
                        montaPainelUrl();

                        document.getElementById('inputUrl').value = montaUrl();

                    });
                });
            </script>
            <div class="creativeCommons" id="creativeCommons">
                <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR"
                   target="_blank"><img alt="Licença Creative Commons" style="border-width:0"
                                     src="http://i.creativecommons.org/l/by-nc/3.0/br/88x31.png" /></a>
                <br/><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/InteractiveResource" property="dct:title" rel="dct:type">Este trabalho</span> está licenciado sob uma <a rel="license" href="http://creativecommons.org/licenses/by-nc/3.0/br/deed.pt_BR" target="_blank">licença Creative Commons Atribuição-NãoComercial 3.0 Brasil</a>.
            </div>
        </div>
    </jsp:attribute>
</vTemplate:basic>
