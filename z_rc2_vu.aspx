<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker.js"></script>
		<script type="text/javascript">
			var t_first=true;
			$(document).ready(function() {
				q_getId();
				q_gt('spec', '1=1 ', 0, 0, 0, "spec");
				
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
				
				$('#q_report').click(function(e) {
					if(window.parent.q_name=="z_contstp_vu"){
						for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
							if($('#q_report').data().info.reportData[i].report!='z_rc2_vu06')
								$('#q_report div div').eq(i).hide();
						}
						$('#q_report div div .radio').parent().each(function(index) {
							if(!$(this).is(':hidden') && t_first){
								$(this).children().removeClass('nonselect').addClass('select');
								t_first=false;
							}
							if($(this).is(':hidden') && t_first){
								$(this).children().removeClass('select').addClass('nonselect');
							}
						});
					}
				});
			});
			var xucolorItem ='';
            var xspecItem ='';
            var t_qno='';
            var xlengthbItem ='';
            var xclassItem ='';
            var xuccItem ='';
			
			function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_rc2_vu',
					options : [{
						type : '0', //[1]
						name : 'accy',
						value : r_accy
					}, {
                        type : '0', //[2] //判斷顯示小數點與其他判斷
                        name : 'lenm',
                        value : r_lenm
                    }, {
                        type : '0', //[3] //判斷顯示小數點與其他判斷
                        name : 'acomp',
                        value : q_getPara('sys.comp')
                    }, {
						type : '1', //[4][5]
						name : 'date'
					}, {
						type : '1', //[6][7]
						name : 'mon'
					}, {
						type : '2', //[8][9]
						name : 'tgg',
						dbf : 'tgg',
						index : 'noa,comp',
						src : 'tgg_b.aspx'
					}, {
                        type : '5',
                        name : 'rc2typea', //[10]
                        value : [q_getPara('report.all')].concat(q_getPara('rc2.typea').split(','))
                    }, {
                        type : '5',
                        name : 'xproduct', //[11]
                        value :xuccItem.split(',')
                    }, {
                        type : '5',
                        name : 'xspec' ,//[12]
                        value :xspecItem.split(',')
                    }, {
                        type : '5',
                        name : 'xsize', //[13]
                        value:(' @全部,#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16,#16').split(',')
                    }, {
                        type : '5',
                        name : 'xclass',//[14]
                        value : xclassItem.split(',')
                    },{
                    	type : '8', //[15]
						name : 'xshowenda',
						value : "1@依號數排序".split(',')
                    },{
                        type : '1',
                        name : 'xlengthb', //[16][17]
                    },{
                        type : '6', //[18] //判斷顯示小數點與其他判斷
                        name : 'qno',
                    }, {
						type : '2', //[19][20]
						name : 'xstore',
						dbf : 'store',
						index : 'noa,store',
						src : 'store_b.aspx'
					}, {
                        type : '0', 
                        name : 'xworker',
                        value : r_name
                    }]
				});
				q_popAssign();
				q_getFormat();
				q_langShow();
               
                var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
					$('#txtDate1').datepicker({dateFormat : 'yy/mm/dd'});
					$('#txtDate2').datepicker({dateFormat : 'yy/mm/dd'});
				}else{
					$('#txtDate1').datepicker();
					$('#txtDate2').datepicker();
				}
				
				$('#txtMon1').mask(r_picm);
                $('#txtMon2').mask(r_picm);
                $('#txtDate1').mask(r_picd);
                $('#txtDate2').mask(r_picd);
				
				$('#txtDate1').val(q_date().substr(0,r_lenm)+'/01');
                $('#txtMon1').val(q_date().substr(0,r_lenm));                
                $('#txtDate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',35).substr(0,r_lenm)+'/01',-1));
                $('#txtMon2').val(q_date().substr(0,r_lenm));
                
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
                
				 	var t_where="where=^^left(datea,7) between '"+$('#txtMon1').val()+"' and '"+$('#txtMon2').val()+
								"' and tggno between '"+$('#txtTgg1a').val()+"' and case when isnull('"+$('#txtTgg2a').val()+"','')='' then char(255) else '"+$('#txtTgg2a').val()+"' end order by datea desc,noa desc  --^^ stop=999 "
					q_gt('cont',t_where, 0, 0, 0, "cont"); 
				 
                 $('.c3.text').change(function(){
                 	var t_where="where=^^left(datea,7) between '"+$('#txtMon1').val()+"' and '"+$('#txtMon2').val()+
								"' and tggno between '"+$('#txtTgg1a').val()+"' and case when isnull('"+$('#txtTgg2a').val()+"','')='' then char(255) else '"+$('#txtTgg2a').val()+"' end order by datea desc,noa desc  --^^ stop=999 "
					q_gt('cont',t_where, 0, 0, 0, "cont");               
                 });
                 $('c2.text').change(function(){
                 	var t_where="where=^^left(datea,7) between '"+$('#txtMon1').val()+"' and '"+$('#txtMon2').val()+
                 				"' and tggno between '"+$('#txtTgg1a').val()+"' and case when isnull('"+$('#txtTgg2a').val()+"','')='' then char(255) else '"+$('#txtTgg2a').val()+"' end order by datea desc,noa desc  --^^ stop=999 "
                 });
                 $('#combQno').click(function() {       	
                 	var t_where="where=^^left(datea,7) between '"+$('#txtMon1').val()+"' and '"+$('#txtMon2').val()+
								"' and tggno between '"+$('#txtTgg1a').val()+"' and case when isnull('"+$('#txtTgg2a').val()+"','')='' then char(255) else '"+$('#txtTgg2a').val()+"' end order by datea desc,noa desc  --^^ stop=999 "
					q_gt('cont',t_where, 0, 0, 0, "cont");
                 });
                $('#combQno').change(function() {
					$('#txtQno').val($('#combQno').find("option:selected").text());
				});
				
				if(window.parent.q_name=="z_contstp_vu"){
					$('#txtQno').val(q_getHref()[1]);
					$('#txtDate1').val(q_getHref()[3].substr(0,r_lenm)+'/01');
					$('#q_report div div .radio.select').click();
				}
				
				$('#Xshowenda').css('width', '300px').css('height', '30px');
				$('#Xshowenda .label').css('width','0px');
				$('#chkXshowenda').css('width', '220px').css('margin-top', '5px');
				$('#chkXshowenda span').css('width','180px')
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(s2) {
			}
			
			function q_gtPost(t_name) {
                switch (t_name) {
                	case 'cont':
                		var as = _q_appendData("cont", "", true);
						for ( i = 0; i < as.length; i++) {
							t_qno+=","+as[i].contract;
						}
						$('#combQno').empty();
						if(t_qno.length != 0){							
								
								 q_cmbParse("combQno", t_qno); 
							}
							t_qno='';
                		break;
                	case 'spec':
                		var as = _q_appendData("spec", "", true);
                		xspecItem = " @全部";
						for ( i = 0; i < as.length; i++) {
							xspecItem+=","+as[i].noa;
						}
						q_gt('color', '1=1 ', 0, 0, 0, "color");
                		break;
                	case 'color':
                		var as = _q_appendData("color", "", true);
                		xucolorItem = " @全部";
						for ( i = 0; i < as.length; i++) {
							xucolorItem+=","+as[i].color;
						}
						q_gt('class', '1=1 ', 0, 0, 0, "class");
                		break;
                	case 'class':
                		var as = _q_appendData("class", "", true);
                		xclassItem = " @全部";
						for ( i = 0; i < as.length; i++) {
							xclassItem+=","+as[i].noa;
						}
						q_gt('ucc', '1=1 ', 0, 0, 0, "ucc"); 
						break;
                	case 'ucc':
						xuccItem = " @全部";
                		var as = _q_appendData("ucc", "", true);
						for ( i = 0; i < as.length; i++) {
							xuccItem+=","+as[i].product;
						}
						
						q_gf('', 'z_rc2_vu');
						break;  
                	default:
                        break;
                }
            }
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
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
		</div>
	</body>
</html>
