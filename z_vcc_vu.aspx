<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="/../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            var gfrun = false;
            var uccgaItem = '',uccgbItem = '',uccgcItem = '';
            var partItem = '';
            var sss_state = false;
            var issale = '0';
            var job = '';
            var sgroup = '';
            var isinvosystem = '';
            var xproductItem ='';
            var xucolorItem ='';
            var xspecItem ='';
            var t_qno='';
            var xlengthbItem ='';
            var xclassItem =''

            if (location.href.indexOf('?') < 0) {
                location.href = location.href + "?;;;;100";
            }
            
            $(document).ready(function() {
                q_getId();
                if (isinvosystem.length == 0) {
                    q_gt('ucca', 'stop=1 ', 0, 0, 0, "ucca_invo");
                }
                if (uccgaItem.length == 0) {
                    q_gt('uccga', '', 0, 0, 0, "");
                }
                if (uccgbItem.length == 0) {
                    q_gt('uccgb', '', 0, 0, 0, "");
                }
                if (uccgcItem.length == 0) {
                    q_gt('uccgc', '', 0, 0, 0, "");
                }
                if (partItem.length == 0) {
                    q_gt('part', '', 0, 0, 0, "");
                }
                if (!sss_state) {
                    q_gt('sss', "where=^^noa='" + r_userno + "'^^", 0, 0, 0, "");
                }
                
                $('#q_report').click(function(e) {
					if(isinvosystem=='2'){//沒有發票系統
	                	$('#Xshowinvono').hide();
	                }
	                if(!(q_getPara('sys.comp').indexOf('英特瑞') > -1 || q_getPara('sys.comp').indexOf('安美得') > -1)){
						$('#Xgroupbno').hide();
						$('#Xgroupcno').hide();
	                }
				});
				_q_boxClose();
                q_getId();
                q_gt('spec', '1=1 ', 0, 0, 0, "spec");
            });
            
            function q_gfPost() {
            	var ucctype=q_getPara('ucc.typea') + ',' + q_getPara('uca.typea');
	            /*if(q_getPara('sys.comp').indexOf('英特瑞') > -1 || q_getPara('sys.comp').indexOf('安美得') > -1)
	            {
	            	ucctype= q_getPara('ucc.typea_it');
	            }*/
	            var vccstype=q_getPara('vcc.stype');
	            /*if(q_getPara('sys.comp').indexOf('永勝') > -1){
	            	vccstype=q_getPara('vcc.stype_uu');
	            }*/
            
                $('#q_report').q_report({
                    fileName : 'z_vcc_vu',
                    options : [{
                        type : '0', //[1] 
                        name : 'accy',
                        value : q_getId()[4]
                    }, {
                        type : '0', //[2] //判斷vcc是內含或應稅
                        name : 'vcctax',
                        value : q_getPara('sys.d4taxtype')
                    }, {
                        type : '0', //[3] //判斷顯示小數點
                        name : 'acomp',
                        value : q_getPara('sys.comp')
                    }, {
                        type : '1', //[4][5]//1
                        name : 'date'
                    }, {
                        type : '1', //[6][7]//2
                        name : 'mon'
                    }, {
                        type : '2', //[8][9]//4
                        name : 'cust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {
                        type : '5',
                        name : 'vcctypea', //[10]//1000
                        value : [q_getPara('report.all')].concat(q_getPara('vcc.typea').split(','))
                    }, {
                        type : '5',
                        name : 'xproduct', //[11]
                        value :q_getPara('vccs_vu.product').split(',')
                    }, {
                        type : '5',
                        name : 'xspec' ,//[12]
                        value :xspecItem.split(',')
                    }, {
                        type : '5',
                        name : 'xsize', //[13]
                        value:(',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16').split(',')
                    }, {
                        type : '5',
                        name : 'xclass',//[14]
                        value : xclassItem.split(',')
                    },{
                        type : '1',
                        name : 'xlengthb', //[15][16]
                        value : xlengthbItem.split(',')
                    },{
                        type : '6', //[14] //判斷顯示小數點與其他判斷
                        name : 'qno',
                      
                    }]
                });
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                 var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
				}else{
					$('#txtDate1').datepicker();
					$('#txtDate2').datepicker();
				}
				
				$('#txtMon1').mask(r_picm);
                $('#txtMon2').mask(r_picm);
          
                $('#txtDate1').mask(r_picd);
				$('#txtDate2').mask(r_picd);

                var t_date, t_year, t_month, t_day;
                t_date = new Date();
                t_date.setDate(1);
                t_year = t_date.getUTCFullYear() - r_1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtDate1').val(t_year + '/' + t_month + '/' + t_day);
                $('#txtMon1').val(t_year + '/' + t_month);

                t_date = new Date();
                t_date.setDate(35);
                t_date.setDate(0);
                t_year = t_date.getUTCFullYear() - r_1911;
                t_year = t_year > 99 ? t_year + '' : '0' + t_year;
                t_month = t_date.getUTCMonth() + 1;
                t_month = t_month > 9 ? t_month + '' : '0' + t_month;
                t_day = t_date.getUTCDate();
                t_day = t_day > 9 ? t_day + '' : '0' + t_day;
                $('#txtDate2').val(t_year + '/' + t_month + '/' + t_day);
                $('#txtMon2').val(t_year + '/' + t_month);
                

                 $('#txtXlengthb1').addClass('num').val(0).change(function() {
                    $(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(0);
                });
                $('#txtXlengthb2').addClass('num').val(99).change(function() {
                    $(this).val(dec($(this).val()));
                    if ($(this).val() == 'NaN')
                    	$(this).val(99);
                });
                
                var tmp = document.getElementById("txtQno");
                var selectbox = document.createElement("select");
                selectbox.id="combQno";
                selectbox.style.cssText ="width:20px;font-size: medium;";
                tmp.parentNode.appendChild(selectbox,tmp);
                q_cmbParse("combQno", t_qno); 
                
                $('#combQno').change(function() {
					$('#txtQno').val($('#combQno').find("option:selected").text());
				});
				
            }

            function q_boxClose(s2) {
            }
            
			//交換div位置
			var exchange = function(a,b){
				try{
					var tmpTop = a.offset().top;
					var tmpLeft = a.offset().left;
					a.offset({top:b.offset().top,left:b.offset().left});
					b.offset({top:tmpTop,left:tmpLeft});
				}catch(e){
				}
			};
			
            function q_gtPost(t_name) {
                switch (t_name) {               	              	
                   case 'sss':
                        var as = _q_appendData("sss", "", true);
                        if (as[0] != undefined) {
                            issale = as[0].issales;
                            job = as[0].job;
                            sgroup = as[0].salesgroup;
                        }
                        sss_state = true;
                        break;
					case 'ucca_invo':
						var as = _q_appendData("ucca", "", true);
						if (as[0] != undefined) {
							isinvosystem = '1';
						} else {
							isinvosystem = '2';
						}
						break;
                    case 'uccga':
                        var as = _q_appendData("uccga", "", true);
                        uccgaItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            uccgaItem = uccgaItem + (uccgaItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].namea;
                        }
                        break;
					case 'uccgb':
                        var as = _q_appendData("uccgb", "", true);
                        uccgbItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            uccgbItem = uccgbItem + (uccgbItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].namea;
                        }
                        break;
					case 'uccgc':
                        var as = _q_appendData("uccgc", "", true);
                        uccgcItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            uccgcItem = uccgcItem + (uccgcItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].namea;
                        }
                        break;
                     case 'part':
                        var as = _q_appendData("part", "", true);
                        partItem = " @全部";
                        for ( i = 0; i < as.length; i++) {
                            partItem = partItem + (partItem.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].noa + ' . ' + as[i].part;
                        }
                        break;   
                        
                    case 'spec':
                		var as = _q_appendData("spec", "", true);
						for ( i = 0; i < as.length; i++) {
							xspecItem+=","+as[i].noa;
						}
						q_gt('color', '1=1 ', 0, 0, 0, "color");
                		break;
                	case 'color':
                		var as = _q_appendData("color", "", true);
						for ( i = 0; i < as.length; i++) {
							xucolorItem+=","+as[i].color;
						}
						q_gt('class', '1=1 ', 0, 0, 0, "class");
                		break;
                	case 'class':
                		var as = _q_appendData("class", "", true);
						for ( i = 0; i < as.length; i++) {
							xclassItem+=","+as[i].noa;
						}
						q_gt('cont', '', 0, 0, 0, "cont");
						break;   
					case 'cont':
                		var as = _q_appendData("cont", "", true);
						for ( i = 0; i < as.length; i++) {
							t_qno+=","+as[i].noa;
						}
						       
                		break;
                	               			
                }
                if (isinvosystem.length > 0 && uccgaItem.length > 0 &&uccgbItem.length > 0 &&uccgcItem.length > 0 && partItem.length > 0 && sss_state && !gfrun) {
                    gfrun = true;
                    q_gf('', 'z_vcc_vu');
                }
                 
            }
            
          
          
          	/*<style type="text/css">
            .num {
                text-align: right;
                padding-right: 2px;
            }
            #q_report select {
            	font-size: medium;
    			margin-top: 2px;
            }
            select {
            	font-size: medium;
            }
		</style>  */
		</script>
		<style type="text/css">
            .num {
                text-align: right;
                padding-right: 2px;
            }
            #q_report select {
            	font-size: medium;
    			margin-top: 2px;
            }
            select {
            	font-size: medium;
            }
		</style> 
	</head>
	
	
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"></div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"></div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<div>
  <div id="q_acDiv"></div>
  <input type="button" id="btnOk"  onMouseOver="this.style.cursor='hand'"  alt=""  style=' font-size: 16px; font-weight:bold;color:blue'/>
  <input id="btnTop" type="button" onclick="q_topPage()"  style="background:url(../image/first_32o.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <input id="btnPrev" type="button" onclick="q_prevPage()"  style="background:url(../image/prev_32o.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <input id="btnNext" type="button" onclick="q_nextPage()"  style="background:url(../image/next_32o.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <input id="btnBott" type="button" onclick="q_bottPage()"  style="background:url(../image/bott_32o.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <input id="txtPageno" value="1" type="text" style=" margin-top: 5px; text-align: center;top:1px; left:110px; width: 45px;"/>
  <label style=" vertical-align: middle;position:inherit; left:165px">/</label>
  <input id="txtEnd" value="XXXX" type="text" style=" vertical-align: middle ;text-align: center; top:1px; left:175px; width: 45px;"/>
  <input id="txtTotpage" value="1" type="hidden"/>
  <input id="txtHtmfile" value="" type="hidden"/>
  <input id="txtUrl2" value="" type="hidden"/>
  <input id="btnPrint" type="button" style="background:url(../image/print_32.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <input id="chkXlsHead" value="" type="checkbox" />
  <input id="btnXls" type="button" style="background:url(../image/excel.jpg) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
    <a id='lblPageRange'></a>
  <input id="txtPageRange" type="text" style='width:40px;'/>
  <input id="btnWebPrint" type="button" style="font-size: medium;color: #0000FF;" value=""/>
  <select id="cmbPcPrinter" style='width:220px;'></select>
  <input id="btnAuthority" type="button"  style="font-size: medium;" />
  <input id="txtUrl" value="" type="text" style='width:70px;'/>
  <input id="btnClose" type="button" onclick=""  style="background:url(../image/colose_32r.png) no-repeat;width: 36px;height: 36px;border-style: hidden;"/>
  <!--<a id='lblPaperSize'></a><a id='lblLandScape'></a>-->
  <select id="cmbPaperSize" style='width:80px;visibility:hidden;'></select>
  <input id="chkLandScape" value="" type="checkbox" style='width:80px;visibility:hidden;'/>
  <div id="frameReport"  style="visibility:visible;top: 35px; left: 0px; height: 100% ; width: 100%; border-top-color:Red; border-top-style:groove;" /div>
</div>
			</div>
		</div>
	</body>
</html>
