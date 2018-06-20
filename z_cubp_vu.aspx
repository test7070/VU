<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src='../script/qj2.js' type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src='../script/qj_mess.js' type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
		<script src='../script/mask.js' type="text/javascript"> </script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"> </script>
		<script src="css/jquery/ui/jquery.ui.widget.js"> </script>
		<script src="css/jquery/ui/jquery.ui.datepicker.js"> </script>
		<script type="text/javascript">
           if (location.href.indexOf('?') < 0) {
				location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
			}
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_cubp_vu');
                
                $.datepicker.regional['zh-TW']={
				   dayNames:["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],
				   dayNamesMin:["日","一","二","三","四","五","六"],
				   monthNames:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
				   monthNamesShort:["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
				   prevText:"上月",
				   nextText:"次月",
				   weekHeader:"週"
				};
				//將預設語系設定為中文
				$.datepicker.setDefaults($.datepicker.regional["zh-TW"]);
				
				$('#btnSvg').val('點線/柱狀圖');
				$('#btnSvg').hide();
				$('#barChart').hide();
				
				$('#q_report').click(function(e) {
					$('#btnSvg').hide();
					$('#barChart').hide();
					$('#dataSearch').show();
					var tindex=$('#q_report').data().info.radioIndex;
					var txtreport=$('#q_report').data().info.reportData[tindex].report;
					if(txtreport=='z_cubp_vu09'){
						$('#btnSvg').show();
					}
				});
				
				$('#btnSvg').click(function() {
					var t_mon=$('#txtYmon').val();
					if(t_mon.length>0){
						q_func('qtxt.query.zcubpsvg91','cuc_vu.txt,zcubpsvg9,'+encodeURI(t_mon));
						$('#Loading').Loading();
						$('#dataSearch').hide();
					}
				});
            });
        	
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_cubp_vu',
					options : [{
                        type : '0', //[1]
                        name : 'projectname',
                        value : q_getPara('sys.project').toUpperCase()
                    }, {
                        type : '0', //[2]
                        name : 'mountprecision',
                        value : q_getPara('rc2.mountPrecision')
                    }, {
                        type : '0', //[3]
                        name : 'weightprecision',
                        value : q_getPara('rc2.weightPrecision')
                    }, {
                        type : '0', //[4]
                        name : 'priceprecision',
                        value : q_getPara('rc2.pricePrecision')
                    },{
                        type : '0', //[5]
                        name : 'xrank',
                        value : r_rank
                    }, {//[6][7]
						type : '1',
						name : 'xdate'
					}, {/*[8][9]*/
                        type : '2',
                        name : 'xmechno',
                        dbf  : 'mech',
                        index: 'noa,mech',
                        src  : 'mech_b.aspx'
                    },{ //[10][11]
						type : '1',
						name : 'xmon'
					},{//[12]
						type : '5',
						name : 'xtype',
						value :('#non@全部,0@未結案,1@已結案').split(',')
					}, {
                        type : '6',
                        name : 'xproduct' //[13]
                    }, {
                        type : '6',
                        name : 'xspec' //[14]
                    }, {
                        type : '5',
                        name : 'xsize', //[15]
                        value:(',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16').split(',')
                    },{//[16]
						type : '5',
						name : 'xshowget',
						value :('Y@含領料,N@不含領料').split(',')
					},{//[17]
						type : '5',
						name : 'xorder',
						value :('noa@案號,comp@客戶,bdate@預交日').split(',')
					}, {//[18][19]
						type : '1',
						name : 'xtime'
					},{//[20]
						type : '5',
						name : 'xsheet',
						value :('Y@含板料,N@不含板料').split(',')
					},{//[21][22]
                        type : '2',
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    },{//[23][24]
                        type : '1',
						name : 'xfdate'
                    },{
                        type : '8', //[25]//
                        name : 'xenda',
                        value : "1@日顯示(日報表)".split(',')
                    }, {
                        type : '6',//[26]
                        name : 'ymon' 
                    }, {
                        type : '6',//[27]
                        name : 'yyear' 
                    }, {
                        type : '6',//[28]
                        name : 'xordeno' 
                    },{
						type : '5',//[29]
						name : 'xmechno2',
						value :('#non@全廠,1剪@A剪,2剪@B剪,3剪@C剪').split(',')
					}]
				});
                q_popAssign();
				q_getFormat();
				q_langShow();
                 
                var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
					$('#txtXdate1').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXdate2').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXfdate1').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtXfdate2').datepicker({dateFormat : 'yy/mm/dd'});
				}else{
					$('#txtXdate1').datepicker();
					$('#txtXdate2').datepicker();
					$('#txtXfdate1').datepicker();
					$('#txtXfdate2').datepicker();
				}
                 
                 $('#txtXdate1').mask(r_picd);
	             $('#txtXdate2').mask(r_picd);
	             $('#txtXfdate1').mask(r_picd);
	             $('#txtXfdate2').mask(r_picd);
	             $('#txtXmon1').mask(r_picm);
	             $('#txtXmon2').mask(r_picm);
	             $('#txtXtime1').mask('99:99');
	             $('#txtXtime2').mask('99:99');
	             
	             $('#txtYmon').mask(r_picm);
	             $('#txtYyear').mask(r_pic);
	             
	             $('#txtYmon').val(q_date().substr(0,r_lenm));
	             $('#txtYyear').val(q_date().substr(0,r_len));
           
           	    //1041201 日期預設 當天
                //$('#txtXdate1').val(q_date());
                //$('#txtXdate2').val(q_date());
                //1050930 預設1號到月底
                $('#txtXdate1').val(q_date().substr(0,r_lenm)+'/01');
                $('#txtXdate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',35).substr(0,r_lenm)+'/01',-1));
                $('#txtXfdate1').val(q_date());
                $('#txtXfdate2').val(q_cdn(q_date(),30));
                
                //1204 預設兩個月 與類別預設顯示 未結案
                $('#txtXmon1').val(q_cdn(q_date().substring(0,r_lenm)+'/01',-25).substring(0,r_lenm));
                $('#txtXmon2').val(q_date().substring(0,r_lenm));
                $('#Xtype select').val('0');
 				
 				/*$('#txtXmon1').blur(function(){
 					if((dec($('#txtXmon2').val().substring(0,r_len))+dec($('#txtXmon2').val().substring(r_len+1,r_lenm)))
 					-(dec($('#txtXmon1').val().substring(0,r_len))+dec($('#txtXmon1').val().substring(r_len+1,r_lenm))) >= 2)
 						alert("月份間距最多選擇2個月");
 				});
 				$('#txtXmon2').blur(function(){
 					if((dec($('#txtXmon2').val().substring(0,r_len))+dec($('#txtXmon2').val().substring(r_len+1,r_lenm)))
 					-(dec($('#txtXmon1').val().substring(0,r_len))+dec($('#txtXmon1').val().substring(r_len+1,r_lenm))) >= 2)
 						alert("月份間距最多選擇2個月");
 				});*/
 				
 				q_gt('spec', '1=1 ', 0, 0, 0, "spec");
 				
 				var tmp = document.getElementById("txtXproduct");
                var selectbox = document.createElement("select");
                selectbox.id="combProduct";
                selectbox.style.cssText ="width:20px;font-size: medium;";
                tmp.parentNode.appendChild(selectbox,tmp);
                //q_cmbParse("combProduct", q_getPara('vccs_vu.product'));
                q_gt('ucc', '1=1 ', 0, 0, 0, "ucc"); 
                
                $('#combProduct').change(function() {
					$('#txtXproduct').val($('#combProduct').find("option:selected").text());
				});
                
                var tmp = document.getElementById("txtXspec");
                var selectbox = document.createElement("select");
                selectbox.id="combSpec";
                selectbox.style.cssText ="width:20px;font-size: medium;";
                tmp.parentNode.appendChild(selectbox,tmp);
                
                $('#combSpec').change(function() {
					$('#txtXspec').val($('#combSpec').find("option:selected").text());
				});
 				
 				if(window.parent.q_name=='cuc'){
 					var t_index=dec(q_getHref()[1])-1;
 					if(t_index<0){
 						t_index=3;
 					}
 					
 					$('#q_report .report div').eq(t_index).click();
 					$('#btnOk').click();
 				}
 				
 				$('#Xenda').css('width', '300px').css('height', '30px');
				$('#Xenda .label').css('width','0px');
				$('#chkXenda').css('width', '220px').css('margin-top', '5px');
				$('#chkXenda span').css('width','180px');
				
				if(q_getPara('sys.project').toUpperCase()=='SF'){
					var t_index=-1;
					for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
						if($('#q_report').data('info').reportData[i].report!='z_cubp_vu08'){
							$('#q_report div div').eq(i).hide();
						}else{
							t_index=i;
						}
					}
					$('#q_report').find('span.radio').eq(t_index).parent().click();	
					$('#txtXnoa').attr('disabled','disabled');
				}
				
				
				var tpara=q_getHref();
				if(tpara!=undefined){
					if(window.parent.q_name=='z_cubp_vu' && tpara[0]=='report'){
						var t_index=-1;
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data('info').reportData[i].report!=tpara[1]){
								$('#q_report div div').eq(i).hide();
							}else{
								t_index=i;
							}
						}
						$('#q_report').find('span.radio').eq(t_index).parent().click();	
						
						if(tpara[2]=='mon'){
							$('#txtYmon').val(tpara[3]);
						}
						$('#btnOk').click();
					}
				}
				
				$('#frameReport').bind('DOMSubtreeModified', function() {
					var radind=$('#q_report').data('info').radioIndex;
					var t_report=$('#q_report').data('info').reportData[radind].report;
					if($('#frameReport table').length>0 ){ //有表再執行
						if(t_report=='z_cubp_vu09' || t_report=='z_cubp_vu10'){
							$('.showdiv1').each(function(index) {
								$(this).click(function(e) {
									var t_id=$(this).attr('id');
									var t_mech=t_id.split('_')[0];
	            					var t_datea=t_id.split('_')[1];
									q_func('qtxt.query.zcubpdiv9_1', 'cuc_vu.txt,zcubpdiv9_1,' + encodeURI(t_datea)+';'+encodeURI(t_mech),r_accy,1);
									var as = _q_appendData("tmp0", "", true, true);
									if (as[0] != undefined) {
										var rowslength=document.getElementById("zcubptable9_1").rows.length-1;
										for (var j = 1; j < rowslength; j++) {
											document.getElementById("zcubptable9_1").deleteRow(1);
										}
										var string='';
										for(var i=0;i<as.length;i++){
											string+='<tr style="background:'+(as[i].z_spec=='合計'?'cornflowerblue':(i%2==0?'darkseagreen':'mediumaquamarine'))+';">';
											string+='<td style="background: '+(as[i].z_spec=='合計'?'blue':'forestgreen')+';">'+as[i].z_spec+'</td>';
											string+='<td>'+as[i].z_3w+'</td>';
											string+='<td>'+as[i].z_4w+'</td>';
											string+='<td>'+as[i].z_5w+'</td>';
											string+='<td>'+as[i].z_6w+'</td>';
											string+='<td>'+as[i].z_7w+'</td>';
											string+='<td>'+as[i].z_8w+'</td>';
											string+='<td>'+as[i].z_9w+'</td>';
											string+='<td>'+as[i].z_10w+'</td>';
											string+='<td>'+as[i].z_11w+'</td>';
											string+='<td>'+as[i].z_12w+'</td>';
											string+='</tr>';
										}
										if(string.length>0){
											$('#zcubptable9_1_head').after(string);
											$('#zcubpdiv9_1').css('top',e.pageY);
											$('#zcubpdiv9_1').css('left',e.pageX-50);
											$('#zcubpdiv9_1').show();
										}
									}
								});
							});
							
							$('.showdiv2').each(function(index) {
								$(this).click(function(e) {
									var t_id=$(this).attr('id');
									var t_mech=t_id.split('_')[0];
	            					var t_datea=t_id.split('_')[1];
	            					
	            					q_func('qtxt.query.zcubpdiv9_2', 'cuc_vu.txt,zcubpdiv9_2,' + encodeURI(t_datea)+';'+encodeURI(t_mech),r_accy,1);
									var as = _q_appendData("tmp0", "", true, true);
									if (as[0] != undefined) {
										var rowslength=document.getElementById("zcubptable9_2").rows.length-1;
										for (var j = 1; j < rowslength; j++) {
											document.getElementById("zcubptable9_2").deleteRow(1);
										}
										var string='';
										for(var i=0;i<as.length;i++){
											string+='<tr style="background: '+(as[i].s_spec=='合計'?'peachpuff':(i%2==0?'#FFE390':'#FFEA93'))+';">';
											string+='<td style="background: '+(as[i].s_spec=='合計'?'burlywood':'gold')+';">'+as[i].s_spec+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_6m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_6w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_7m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_7w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_8m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_8w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_9m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_9w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_10m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_10w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_11m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_11w,3)+'</td>';
											string+='<td style="width: 50px;">'+as[i].s_12m+'</td>';
											string+='<td style="width: 80px;">'+round(as[i].s_12w,3)+'</td>';
											string+='</tr>';
										}
										if(string.length>0){
											$('#zcubptable9_2_head').after(string);
											$('#zcubpdiv9_2').css('top',e.pageY);
											$('#zcubpdiv9_2').css('left',e.pageX-50);
											$('#zcubpdiv9_2').show();
										}
									}
	            				});
							});
						}
					}
					$('#zcubpdiv9_1').hide();
					$('#zcubpdiv9_2').hide();
				});
				
				$('#zcubptable9_1close').click(function() {
					$('#zcubpdiv9_1').hide();
				});
				$('#zcubptable9_2close').click(function() {
					$('#zcubpdiv9_2').hide();
				});
			}
			
            function q_boxClose(s2) {
            }
            
            var t_spec='@'
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'spec':
                		var as = _q_appendData("spec", "", true);
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec); 
                		break;
                	case 'ucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc);
						break;
                    default:
                        break;
                }
            }
            
            function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.zcubpsvg91'://點線 & //柱狀
                		var as = _q_appendData("tmp0", "", true, true);
                		if (as[0] != undefined) {
                			var bar=$.extend(true,[], as);
                			var x_maxweight=0,x_minweight=999999999;
                			for (var i = 0; i < as.length; i++) {
                				var ttweight=0;
                				ttweight=
                				q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(
                				q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(
                				q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(q_add(
                				dec(as[i].d_01),dec(as[i].d_02)),dec(as[i].d_03)),dec(as[i].d_04)),dec(as[i].d_05)),
                				dec(as[i].d_06)),dec(as[i].d_07)),dec(as[i].d_08)),dec(as[i].d_09)),dec(as[i].d_10)),
                				dec(as[i].d_11)),dec(as[i].d_12)),dec(as[i].d_13)),dec(as[i].d_14)),dec(as[i].d_15)),
                				dec(as[i].d_16)),dec(as[i].d_17)),dec(as[i].d_18)),dec(as[i].d_19)),dec(as[i].d_20)),
                				dec(as[i].d_21)),dec(as[i].d_22)),dec(as[i].d_23)),dec(as[i].d_24)),dec(as[i].d_25)),
                				dec(as[i].d_26)),dec(as[i].d_27)),dec(as[i].d_28)),dec(as[i].d_29)),dec(as[i].d_30)),dec(as[i].d_31));
                				
                				x_maxweight=Math.max(x_maxweight,dec(ttweight));
                				x_minweight=Math.min(x_minweight,dec(as[i].d_01));
                			}
                			
                			$('#barChart').barChart({
								data : bar,
								maxweight : x_maxweight,
								minweight : x_minweight,
							});
							$('#Loading').hide();
	                        $('#barChart').show();
                		}else{
                			alert('無資料內容!!');
                			$('#dataSearch').show();
                		}
                		break;
                }
			}
            
            ;(function($, undefined) {
				$.fn.Loading = function() {
                    $(this).data('info', {
                        init : function(obj) {
                            obj.html('').width(250).height(100).show();
                            var tmpPath = '<defs>' + '<filter id="f1" x="0" y="0">' + '<feGaussianBlur in="SourceGraphic" stdDeviation="5" />' + '</filter>' + '<filter id="f2" x="0" y="0">' + '<feGaussianBlur in="SourceGraphic" stdDeviation="5" />' + '</filter>' + '</defs>' + '<rect width="200" height="10" fill="yellow" filter="url(#f1)"/>' + '<rect x="0" y="0" width="20" height="10" fill="RGB(223,116,1)" stroke="yellow" stroke-width="2" filter="url(#f2)">' + '<animate attributeName="x" attributeType="XML" begin="0s" dur="6s" fill="freeze" from="0" to="200" repeatCount="indefinite"/>' + '</rect>';
                            tmpPath += '<text x="40" y="35" fill="black">資料讀取中...</text>';
                            obj.append('<svg xmlns="http://www.w3.org/2000/svg" version="1.1" class="graph">' + tmpPath + '</svg> ');
                        }
                    });
                    $(this).data('info').init($(this));
                }
                $.fn.barChart = function(value) {
                	$(this).data('info', {
						Data : value.data,
                		maxWeight : value.maxweight,
                        minWeight : value.minweight,
                        init : function(obj) {
                            if (value.length == 0) {
                                alert('無資料。');
                                return;
                            }
                            obj.data('info').refresh(obj);
                        },
                        refresh : function(obj) {
                        	obj.width(1200).height(600);
                        	var objWidth = 1200;
                            var objHeight = 600;
                        	//背景
                            var tmpPath = '<rect x="0" y="0" width="' + objWidth + '" height="' + objHeight + '" style="fill:rgb(255,255,255);stroke-width:1;stroke:rgb(0,0,0)"/>';
                            //圖表背景顏色
                            var t_color1 = ['rgb(210,233,255)', 'rgb(235,255,255)'];
                            var t_n = 20;
                        	//圖表分幾個區塊
                            var t_height = 500, t_width = 950;
                            for (var i = 0; i < t_n; i++)
                                tmpPath += '<rect x="100" y="' + (50 + (t_height / t_n) * i) + '" width="' + t_width + '" height="' + (t_height / t_n) + '" style="fill:' + t_color1[i % t_color1.length] + ';"/>';                          
                            
                            var t_unit = 'KG',t_uweight=1;
                            var t_maxWeight = obj.data('info').maxWeight;
                            var t_minWeight = obj.data('info').minWeight;
                            
                            if(t_maxWeight>50000){
                            	t_unit = '頓',t_uweight=1000;
                            	t_maxWeight=Math.ceil(q_div(t_maxWeight/t_uweight));
                            	t_minWeight=Math.floor(q_div(t_minWeight/t_uweight));
                            }else{
                            	t_maxWeight=q_add(t_maxWeight,500);
                            }
                            
                            //Y軸
                            tmpPath += '<line x1="100" y1="50" x2="100" y2="' + (50 + t_height) + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
                            tmpPath += '<text x="' + (50 + t_width + 50) + '" y="' + (50 + t_height + 30) + '" fill="black">日</text>';
                            //X軸
                            var t_Y = 50 + t_height - round((0 - t_minWeight) / (t_maxWeight - t_minWeight) * t_height, 0);
                            tmpPath += '<line x1="100" y1="' + (t_Y) + '" x2="' + (100 + t_width) + '" y2="' + (t_Y) + '" style="stroke:rgb(0,0,0);stroke-width:1"/>';
                            tmpPath += '<text x="' + (70) + '" y="' + (20) + '" fill="black">'+t_unit+'</text>';
                            //X軸旁邊標記
                            tmpPath += '<line x1="95" y1="' + t_Y + '" x2="100" y2="' + t_Y + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
                            tmpPath += '<text text-anchor="end" x="90" y="' + t_Y + '" fill="black">0</text>';
                            
                            tmpPath += '<text text-anchor="end" x="90" y="' + (50) + '" fill="black">' + FormatNumber(t_maxWeight) + '</text>';
                            tmpPath += '<line x1="95" y1="50" x2="100" y2="50" style="stroke:rgb(0,0,0);stroke-width:2"/>';
                            tmpPath += '<text text-anchor="end" x="90" y="' + (50 + t_height) + '" fill="black">' + FormatNumber(t_minWeight) + '</text>';
                            tmpPath += '<line x1="95" y1="' + (50 + t_height) + '" x2="100" y2="' + (50 + t_height) + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
                            
                            var t_range = round((t_maxWeight - t_minWeight)/20,0);
                            var i = Math.pow(10,(t_range+'').length-1);
                            var t_range = Math.floor(t_range/i)*i;
                            t_weight = t_range;
                            while (t_weight < t_maxWeight) {
                            	if((t_maxWeight-t_weight)/(t_maxWeight - t_minWeight)>0.005){
	                                y = t_Y - round(t_weight / (t_maxWeight - t_minWeight) * t_height, 0);
	                                tmpPath += '<line x1="95" y1="' + y + '" x2="100" y2="' + y + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
	                                tmpPath += '<text text-anchor="end" x="90" y="' + y + '" fill="black">' + FormatNumber(t_weight)+ '</text>';
                            	}
                            	t_weight += t_range;
                            }
                            t_weight = -t_range;
                            while (t_weight > t_minWeight) {
                            	if(Math.abs(t_minWeight-t_weight)/(t_maxWeight - t_minWeight)>0.005){
	                                x = 90;
	                                y = t_Y - round(t_weight / (t_maxWeight - t_minWeight) * t_height, 0);
	                                tmpPath += '<line x1="95" y1="' + y + '" x2="100" y2="' + y + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
	                                tmpPath += '<text text-anchor="end" x="90" y="' + y + '" fill="black">' + FormatNumber(t_weight) + '</text>';
                               	}
                               	t_weight -= t_range;
                            }
                            
                            //Y軸旁邊標記 日期
                            var t_n=round((t_width - 20) / 31, 0);
                            var t_nw=Math.floor((t_n-10)/3);//柱狀寬度
                            var x, h, y, bx, by;
                            for(var j=1; j<=31; j++){
                            	var str_j=('000'+j).slice(-2);
                            	x = 100 + 20 + t_n * (j-1);
                            	tmpPath += '<line x1="' + x + '" y1="' + (t_height+50) + '" x2="' + x + '" y2="' + (t_height+60) + '" style="stroke:rgb(0,0,0);stroke-width:2"/>';
                            	tmpPath += '<text text-anchor="middle" x="'+(x)+'" y="' + (t_height+75) + '" fill="black">' + str_j + '</text>';
                            }
                            
                            
                            var t_detail = obj.data('info').Data;
                            var t_color2 = ['rgb(255,255,0)', 'rgb(0,255,0)', 'rgb(255,0,0)'];
                            for (var i = 0; i < t_detail.length && i<3; i++) {//連接線
                            	var t_weight=0; //累加重量
                            	//符號說明
                            	tmpPath += '<rect x="1090" y="'+(65+(i*40))+'" width="20" height="20" fill="'+t_color2[i]+'"/>';
                            	tmpPath += '<line x1="1120" y1="'+(75+(i*40))+'" x2="1140" y2="'+(75+(i*40))+'" style="stroke:rgb(0,0,0);stroke-width:1"/>';
	                            tmpPath += '<circle class="" cx="1130" cy="'+(75+(i*40))+'" r="5" stroke="black" stroke-width="2" fill="'+t_color2[i]+'"/>';
	                            tmpPath += '<text x="1150" y="'+(80+(i*40))+'" fill="black">'+t_detail[i].worker+'</text>';
                            	
                            	for(var j=1; j<=31; j++){
									x = 100 + 20 + t_n * (j-1);
									var str_j=('000'+j).slice(-2);
									
									//柱狀
									eval('h = Math.abs(round(q_div(dec(t_detail[i].d_'+str_j+'),t_uweight) / (t_maxWeight+t_minWeight) * t_height, 0))');
									tmpPath += '<rect id="barChart_profit'+i+'_'+j+'" x="' + (x-Math.ceil(t_n/3)+(i*t_nw)) + '" y="' + (q_sub(q_add(t_height,50),h)) + '" width="' + t_nw + '" height="' + h + '" fill="'+t_color2[i]+'"/>';
									
									//點線
									eval('t_weight=q_add(t_weight,q_div(dec(t_detail[i].d_'+str_j+'),t_uweight))');
									y = t_Y - round(t_weight / (t_maxWeight+Math.abs(t_minWeight)) * t_height, 0);
									
									if (j > 1) //第一條線不用畫
										tmpPath += '<line x1="' + bx + '" y1="' + by + '" x2="' + x + '" y2="' + y + '" style="stroke:'+t_color2[i]+';stroke-width:1"/>';
									tmpPath += '<circle id="barChart_in' + i + '_'+j+'" class="barChart_in" class="" cx="' + x + '" cy="' + y + '" r="5" stroke="black" stroke-width="2" fill="'+t_color2[i]+'"/>';
									
									bx = x;
									by = y;
								}
							}
                        	
                        	obj.html('<svg xmlns="http://www.w3.org/2000/svg" version="1.1" class="graph">' + tmpPath + '</svg> ');
                        }
                	});
                	$(this).data('info').init($(this));
                }
                
            })($);
            
            function FormatNumber(n) {
                n += "";
                var arr = n.split(".");
                var re = /(\d{1,3})(?=(\d{3})+$)/g;
                return arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
            }
		</script>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div id="svgbet" style="display:inline-block;width:2000px;">
				<input id="btnSvg" type="button" style="font-size: medium;"/>
			</div>
			<div id='dataSearch' class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>		
		
		<div id='Loading'> </div>
		<div id='barChart'> </div>
		
		<div id="zcubpdiv9_1" style="display: none;position:absolute;background: darkgray;">
			<table id="zcubptable9_1" style="text-align: center;color: white;font-size: medium;">
				<tr style="background: forestgreen;" id="zcubptable9_1_head">
					<td style="width: 75px;">號數</td>
					<td style="width: 75px;">#3</td>
					<td style="width: 75px;">#4</td>
					<td style="width: 75px;">#5</td>
					<td style="width: 75px;">#6</td>
					<td style="width: 75px;">#7</td>
					<td style="width: 75px;">#8</td>
					<td style="width: 75px;">#9</td>
					<td style="width: 75px;">#10</td>
					<td style="width: 75px;">#11</td>
					<td style="width: 75px;">#12</td>
				</tr>
				<tr style="background: forestgreen;">
					<td colspan="11"><input id="zcubptable9_1close" type="button" value="關閉"></td>
				</tr>
			</table>
		</div>
		<div id="zcubpdiv9_2" style="display: none;position:absolute;background: darkgray;">
			<table id="zcubptable9_2" style="text-align: center;color: white;font-size: medium;">
				<tr style="background: gold;" id="zcubptable9_2_head">
					<td style="width: 115px;">車牙頭數</td>
					<td style="width: 130px;" colspan="2">#6</td>
					<td style="width: 130px;" colspan="2">#7</td>
					<td style="width: 130px;" colspan="2">#8</td>
					<td style="width: 130px;" colspan="2">#9</td>
					<td style="width: 130px;" colspan="2">#10</td>
					<td style="width: 130px;" colspan="2">#11</td>
					<td style="width: 130px;" colspan="2">#12</td>
				</tr>
				<tr style="background: gold;">
					<td colspan="15"><input id="zcubptable9_2close" type="button" value="關閉"></td>
				</tr>
			</table>
		</div>
	</body>
</html>