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
		
			$(document).ready(function() {
				q_getId();
				q_gt('ucc', '1=1 ', 0, 0, 0, "ucc"); 
				
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
			});
			var xuccItem ='';
			var t_qno='';
			
			function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_rc2_vu',
					options : [{
						type : '0', //[1]
						name : 'accy',
						value : r_accy
					}, {
						type : '1', //[2][3]
						name : 'date'
					}, {
						type : '1', //[4][5]
						name : 'mon'
					}, {
						type : '2', //[6][7]
						name : 'tgg',
						dbf : 'tgg',
						index : 'noa,comp',
						src : 'tgg_b.aspx'
					}, {
						type : '2', //[8][9]
						name : 'sales',
						dbf : 'sss',
						index : 'noa,namea',
						src : 'sss_b.aspx'
					}, {
						type : '2', //[10][11]
						name : 'product',
						dbf : 'ucc',
						index : 'noa,product',
						src : 'ucc_b.aspx'
					}, {
						type : '5', //[12]
						name : 'xstype',
						value : xuccItem.split(',')
					}, {
                        type : '0', //[13] //判斷顯示小數點與其他判斷
                        name : 'acomp',
                        value : q_getPara('sys.comp')
                    },{
                        type : '6', //[14] //判斷顯示小數點與其他判斷
                        name : 'qno',
                    }, {
						type : '2', //[15][16]
						name : 'xstore',
						dbf : 'store',
						index : 'noa,store',
						src : 'store_b.aspx'
					}, {
                        type : '0', //[17] //判斷顯示小數點與其他判斷
                        name : 'lenm',
                        value : r_lenm
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
							t_qno+=","+as[i].noa;
						}
						$('#combQno').empty();
						if(t_qno.length != 0){							
								
								 q_cmbParse("combQno", t_qno); 
							}
							t_qno='';
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
