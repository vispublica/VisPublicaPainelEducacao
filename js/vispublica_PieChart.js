/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

function initPieChart(container){
    dataPieChart = {
        titulo: "Titulo",
        ano: 0,
        local: "",
        etapa: "",
        estado: "",
        grupo: "",
        setores: [
        {
            cat:"cat0",
            color:"#5CACEE",
            val:0
        },
        {
            cat:"cat1",
            color:"#EE6A50",
            val:0
        },
        {
            cat:"cat2",
            color:"#CDC8B1",
            val:0
        }
        ]
    };
    
    widthPieChart = 500,
    heightPieChart = 410,
    marginPieChart = 150,
    radius = (Math.min(widthPieChart - marginPieChart, heightPieChart - marginPieChart) / 2) - 30 ,  
    // Pie layout will use the "val" property of each data object entry
    pieChart = d3.layout.pie().sort(null).value(function(d){
        return d.val;
    }), 
    arc = d3.svg.arc().outerRadius(radius),
    pos = d3.svg.arc().innerRadius(radius + 35).outerRadius(radius + 28); 
    posR = d3.svg.arc().innerRadius(radius + 35).outerRadius(radius + 60);
    posA = d3.svg.arc().innerRadius(radius + 60).outerRadius(radius + 28); 
    
    // SVG elements init
    textSubGroup = d3.select("div."+container).select(".wrapperTitle");
    
    svg = d3.select("div."+container).append("svg")
    .attr("width", widthPieChart)
    .attr("height", heightPieChart),  
            
    defs = svg.append("svg:defs"),
    // Declare a main gradient with the dimensions for all gradient entries to refer
    mainGrad = defs.append("svg:radialGradient")
    .attr("gradientUnits", "userSpaceOnUse")  
    .attr("cx", 0).attr("cy", 0).attr("r", radius).attr("fx", 0).attr("fy", 0)
    .attr("id", "master"),
    // The pie sectors container
    arcGroup = svg.append("svg:g")
    .attr("class", "arcGroup")
    .attr("filter", "url(#shadow)")
    .attr("transform", "translate(" + ((widthPieChart / 2)-50) + "," + ((heightPieChart / 2)-60) + ")"),
				  
    //Grupo das labels
    lblGroup = svg.append("svg:g")
    .attr("class", "lblGroup")
    .attr("transform", "translate(" + ((widthPieChart / 2)-80) + "," + ((heightPieChart / 2)-52) + ")");	
            
    legendGroup = svg.append("svg:g")
    .attr("class", "lengendGroupPie")
    .attr("transform", "translate(" + ((widthPieChart/2)+260)  + "," + ((heightPieChart/2)-295) + ")");	
 
    // Declare shadow filter
    shadow = defs.append("filter").attr("id", "shadow")
    .attr("filterUnits", "userSpaceOnUse")
    .attr("x", -1*(widthPieChart / 2)).attr("y", -1*(heightPieChart / 2))
    .attr("width", widthPieChart).attr("height", heightPieChart);
    shadow.append("feGaussianBlur")
    .attr("in", "SourceAlpha")
    .attr("stdDeviation", "4")
    .attr("result", "blur");
    shadow.append("feOffset")
    .attr("in", "blur")
    .attr("dx", "4").attr("dy", "4")
    .attr("result", "offsetBlur");
    shadow.append("feBlend")
    .attr("in", "SourceGraphic")
    .attr("in2", "offsetBlur")
    .attr("mode", "normal");
		  
    var currData = dataPieChart.setores;
	  
    // Create a gradient for each entry (each entry identified by its unique category)
    gradients = defs.selectAll(".gradient").data(currData, function(d){
        return d.cat;
    });      
    gradients.enter().append("svg:radialGradient")
    .attr("id", function(d, i) {
        return "gradient" + d.cat;
    })
    .attr("class", "gradient")
    .attr("xlink:href", "#master");    
 
    gradients.append("svg:stop").attr("offset", "0%").attr("stop-color", getColor );
    gradients.append("svg:stop").attr("offset", "90%").attr("stop-color", getColor );
    gradients.append("svg:stop").attr("offset", "100%").attr("stop-color", getDarkerColor );      

    // Create a sector for each entry in the enter selection
    paths = arcGroup.selectAll("path")
    .data(pieChart(currData), function(d) {
        return d.data.cat;
    } );
    paths.enter().append("svg:path").attr("class", "sector").attr("name", function(d) {
        return d.data.cat;
    } );

    // Each sector will refer to its gradient fill
    paths.attr("fill", function(d, i) {
        return "url(#gradient"+d.data.cat+")";
    })
		
    //Adicionar label
    arcs = lblGroup.selectAll("text")
    .data(pieChart(currData), function(d) {
        return d.data.cat;
    })
		
    arcs.enter().append("svg:text").transition().ease("elastic").duration(500)
    .attr("dy", 5)
    .attr("class", "label")
    .attr("name", function(d) {
        return d.data.cat;
    });
    //.attr("text-anchor", "middle") 
            
    //Adicionar Legenda
    legendColor = legendGroup.selectAll("rect")
    .data(pieChart(currData), function(d) {
        return d.data.cat;
    })
            
    legendColor.enter().append("svg:rect").transition().duration(500)
    .attr("transform", function(d, i) {
        return "translate(" + 
        ((i*120-500)+((i==2?10:0))) + "," + (377) + ")";
    }) 
    .attr("height", 15)
    .attr("width", 20);
            
    legend = legendGroup.selectAll("text")
    .data(pieChart(currData), function(d) {
        return d.data.cat;
    });
            
    legend.enter().append("svg:text").transition().duration(500)
    .attr("transform", function(d, i) {
        return "translate(" + 
        ((i*120-475)+((i==2?10:0))) + "," + (390) + ")";
    }) 
    .attr("text-anchor", "left") 
    .attr("fill","#363636")
    .style("font-size", "17px")
    
    paths.on("mouseover", function(d){              
        if(this._listenToEvents){
            
            d3.select(".lblGroup").selectAll("text").attr("opacity",0.1);
 
            d3.select(".lblGroup").select(".label[name='"+d3.select(this).attr("name")+"']").attr().attr("opacity",1);
        }
    })
    .on("mouseout", function(d){              
        if(this._listenToEvents){      
            d3.select(".lblGroup").selectAll("text").attr("opacity",1);
        }
    });
 
    // Collapse sectors for the exit selection
    paths.exit().transition()
    .duration(1000)
    .attrTween("d", tweenOut).remove(); 
                
    
                
}
 
// "Fold" pie sectors by tweening its current start/end angles
// into 2*PI
function tweenOut(data) {
    data.startAngle = data.endAngle = (2 * Math.PI);      
    var interpolation = d3.interpolate(this._current, data);
    this._current = interpolation(0);
    return function(t) {
        return arc(interpolation(t));
    };
}
 
// "Unfold" pie sectors by tweening its start/end angles
// from 0 into their final calculated values
function tweenIn(data) {
    var interpolation = d3.interpolate({
        startAngle: 0, 
        endAngle: 0
    }, data);
    this._current = interpolation(0);
    return function(t) {
        return arc(interpolation(t));
    };
}

// Helper function to extract color from data object
function getColor(data, index){
    return data.color;
}

// Helper function to extract a darker version of the color
function getDarkerColor(data, index){
    return d3.rgb(getColor(data, index)).darker();
}

function updatePieChart(dataModel){     
            
    var validaValores = 0;
                
    for(var i=0; i<dataModel.setores.length;i++){ 
        if(dataModel.setores[i].val > 0){
            validaValores = 1;
        }
    }
    
    if(validaValores == 0){
        dataModel.setores[0].val = 1; 
    }
    
    paths.data(pieChart(dataModel.setores), function(d) {
        return d.data.cat;
    } )
    .attr("fill",function(d, i){
        return "url(#gradient"+d.data.cat+")"
    });
    ;   
              
    arcs.data(pieChart(dataModel.setores), function(d) {
        return d.data.cat;
    });
    
                
    var SubTitulo = "";
                
    if(validaValores == 1){
        SubTitulo = dataModel.titulo;
          
        paths.transition().duration(500).attrTween("d", tweenIn).each("end", function(){
            this._listenToEvents = true;
        });      
        
        arcs.transition().duration(250)
        .attr("transform", function(d, i) {
            return "translate(" + pos.centroid(d) + ")";
        })
        .attr("dx", function(d, i) {
            return (i==0)?10:((i==1)?-15:((d.data.val>30)?0:30));
        })
        .attr("dy", function(d, i) {
            return d.data.val > 15 ? -10 : 5;
        })
        .attr("fill","#363636")
        .style("font-size", "18px")
        .text(function(d, i) {
            if(d.data.val > 0){
                return d.data.val.toFixed(2) + "%"
            } else {
                return
            }
        });
        textSubGroup.text(SubTitulo)
        .style("font-size", "16px")
        .attr("text-anchor", "middle");
        
        legendGroup.selectAll("rect").
        attr("visibility", "show");
        
    } else { 
        SubTitulo = "Dados Insuficientes para criar a visualização";
        
        
        paths.transition().duration(500).attrTween("d", tweenIn).each("end", function(){
            this._listenToEvents = true;
        })
        .attr("fill", "#CDC8B1");
        
        arcs.transition()
        .attr("transform", "translate(-57, -5)")
        .attr("fill","#363636")
        .attr("dx", 0)
        .attr("dy", 0)
        .style("font-size", "20px")
        .text(function(d, i) {
            if(i == 0){
                return "Dados Insuficientes"
            } else {
                return 
            }
        });
        
        textSubGroup.text(SubTitulo)
        .style("font-size", "19px")
        .attr("text-anchor", "middle");
        
        legendGroup.selectAll("rect").
        attr("visibility", "hidden");
    }
                
    
                
    legendGroup.selectAll("text").text(function(d, i) { 
        if(i==0){
            return (validaValores == 1)?"Aprovação":""
        }else if (i==1){
            return (validaValores == 1)?"Reprovação":""
        }else if (i==2){
            return (validaValores == 1)?"Abandono":""
        }
    }); 
                

    legendGroup.selectAll("rect").attr("fill",function(d, i) { 
        if(i==0){
            return "#5CACEE"
        }else if (i==1){
            return "#EE6A50"
        }else if (i==2){
            return "#CDC8B1"
        }
    }); 
    
}
            
function updateDataPieChart(anoIndex, titulo, localPie, etapaPie, grupoPie){
    
    if(dataPieChart.ano != anoIndex || dataPieChart.local != localPie || dataPieChart.etapa != etapaPie
        || dataPieChart.estado != titulo || dataPieChart.grupo != grupoPie){
        
        var val1 = 0;
        var val2 = 0;
        var val3 = 0;
        
        if(grupoPie == "Todos"){
            val1 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Total"].aprovacoes[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Total"].aprovacoes[14];
            val2 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Total"].reprovacoes[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Total"].reprovacoes[14];
            val3 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Total"].abandonos[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Total"].abandonos[14];
        } else if (grupoPie == "Mun. / Fed. / Est."){
            val1 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[14];
            val2 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[14];
            val3 = (etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[13] :
            dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[14];
        } else if (grupoPie == "Part. / Publico"){
            var validaval1;
            var validaVal2;
            var validaVal3;
            var validaParticular = false;
            
            if(dadosDashboard[anoIndex].locais[localPie].redes["Particular"]){
                validaParticular = true;
            }
            
            var auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].aprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].aprovacoes[14])):0;
            var auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[14]);
                        
            val1 = (auxParticular + auxPublico)/(auxParticular == 0 ? 1:(auxPublico == 0 ? 1 : 2));
            validaval1= (auxParticular == 0 ? 0:(auxPublico == 0 ? 0 : 1));
            
            auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].reprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].reprovacoes[14])):0;
            auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[14]);
            
            val2 = (auxParticular + auxPublico)/(auxParticular == 0 ? 1:(auxPublico == 0 ? 1 : 2));   
            validaVal2 = (auxParticular == 0 ? 0:(auxPublico == 0 ? 0 : 1));
            
            auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].abandonos[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].abandonos[14])):0;
            auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[14]);
            
            val3 = (auxParticular + auxPublico)/(auxParticular == 0 ? 1:(auxPublico == 0 ? 1 : 2));
            validaVal3 = (auxParticular == 0 ? 0:(auxPublico == 0 ? 0 : 1));
            
            if(val3 == 0  ){
                val2 = ((val1+val2) >= 99.1) ? val2 : val2/2;
            } else if (val2 == 0 ){
                val3 = ((val1+val3) >= 99.1) ? val3 : val3/2;
            } 
            if (validaVal3 == 0){
                val3 = ((val1+val2+val3) >= 99.1 && (val1+val2+val3) <= 100.1) ? val3 : val3/2;
            }
            if (validaVal2 == 0){
                val2 = ((val1+val2+val3) >= 99.1 && (val1+val2+val3) <= 100.1) ? val2 : val2/2;
            }
            if (validaval1 == 0){
                val1 = ((val1+val2+val3) >= 99.1 && (val1+val2+val3) <= 100.1) ? val1 : val1/2;
            } 
           /* 
            var validaParticular = false;
            
            if(dadosDashboard[anoIndex].locais[localPie].redes["Particular"]){
                validaParticular = true;
            }
            
            var auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].aprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].aprovacoes[14])):-1;
            var auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].aprovacoes[14]);
            
            val1 = (auxParticular == -1)?((auxPublico == -1)?0:auxPublico):((auxPublico == -1)?auxParticular:((auxParticular + auxPublico)/2));
            
            auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].reprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].reprovacoes[14])):0;
            auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].reprovacoes[14]);
            
            val2 = (auxParticular == -1)?((auxPublico == -1)?0:auxPublico):((auxPublico == -1)?auxParticular:((auxParticular + auxPublico)/2));
            
            auxParticular = validaParticular?(((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Particular"].abandonos[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Particular"].abandonos[14])):0;
            auxPublico = ((etapaPie == "fundamental") ? dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[13] :
                dadosDashboard[anoIndex].locais[localPie].redes["Publico"].abandonos[14]);
            
            val3 = (auxParticular == -1)?((auxPublico == -1)?0:auxPublico):((auxPublico == -1)?auxParticular:((auxParticular + auxPublico)/2));
            */
        }
        
        dataPieChart = {
            //REVER TITULO (Falta local)
            titulo: "Rendimento Total no Ensino "+ ((etapaPie == "fundamental")?"Fundamental":"Médio")+" na Zona "+((localPie=="Total")?"Urbana/Rural":localPie)+" ("+titulo+" / "+anoIndex+")",
            ano: anoIndex,
            local: localPie,
            etapa: etapaPie,
            estado: titulo,
            grupo: grupoPie,
            setores: [
            {
                cat:"cat0",
                color:"#5CACEE",
                val: val1
            },
            {
                cat:"cat1",
                color:"#EE6A50",
                val: val2
            },
            {
                cat:"cat2",
                color:"#CDC8B1",
                val: val3
            }
            ]
        };
        updatePieChart(dataPieChart);
    } else {
        return;
    }
    
    
}