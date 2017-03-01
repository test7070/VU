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
            /*$(document).ready(function() {
            	q_getId();
                q_gf('', 'z_cucp_vu');
            });*/
           $(document).ready(function() {
                _q_boxClose();
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
            });
        	
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_cucp_vu',
					options : [
					{	//[1][2]
						type : '1',
						name : 'xnoa'
					}, {//[3][4]
                        type : '2',
                        name : 'product', 
                        dbf : 'ucaucc',
                        index : 'noa,product',
                        src : 'ucaucc_b.aspx'
                    }, {//[5]
                        type : '6',
                        name : 'xuno'
                    }, {//[6]
                        type : '6',
                        name : 'edate' 
                    }, {//[7]
                        type : '6',
                        name : 'xspec' 
                    }, {//[8]
                        type : '5',
                        name : 'xsize',
                        value:(',#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,#16').split(',')
                    }, {//[9][10]
                        type : '1',
                        name : 'xlengthb'
                    }, {//[11]
                        type : '6',
                        name : 'xclass'
                    }, {//[12][13]
                        type : '2',
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {//[14][15]
                        type : '1',
                        name : 'xordeno'
                    }, {
                        type : '1', //[16][17]
                        name : 'xdate'
                    }, {//[18]
                        type : '6',
                        name : 'xbdate' 
                    }]
				});
                q_popAssign();
				q_getFormat();
				q_langShow();
				
                 if(q_getHref()[0]=='noa' &&q_getHref()[1].length>0 && q_getHref()[1]!= undefined){
					$('#txtXnoa1').val(q_getHref()[1]);
                    $('#txtXnoa2').val(q_getHref()[1]);
				}
				
				$('#txtEdate').mask(r_picd);
                $('#txtEdate').val(q_date());
                $('#txtEdate').datepicker({dateFormat : 'yy/mm/dd'});
                
                if(r_len==4){                	
                	$.datepicker.r_len=4;
					//$.datepicker.setDefaults($.datepicker.regional["ENG"]);
                }

                $('#txtXdate1').mask(r_picd);
                $('#txtXdate1').datepicker();
                $('#txtXdate2').mask(r_picd);
                $('#txtXdate2').datepicker();

				$('#txtXdate1').val(q_date().substr(0,r_lenm)+'/01');
				$('#txtXdate2').val(q_cdn(q_cdn(q_date().substr(0,r_lenm)+'/01',45).substr(0,r_lenm)+'/01',-1));
                
                $('#txtXbdate').mask(r_picd);
                $('#txtXbdate').datepicker({dateFormat : 'yy/mm/dd'});
                
                $("#Xlengthb").css('width', '302px');
                $("#Xlengthb input").css('width', '90px');
                
                $('#txtXsize').change(function() {
                    if ($('#txtXsize').val().substr(0, 1) != '#')
                        $('#txtXsize').val('#' + $('#txtXsize').val());
                });

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
                
                var tmp = document.getElementById("txtXspec");
                var selectbox = document.createElement("select");
                selectbox.id="combSpec";
                selectbox.style.cssText ="width:20px;font-size: medium;";
                tmp.parentNode.appendChild(selectbox,tmp);
                q_cmbParse("combSpec", t_spec); 
                 $('#combSpec').change(function() {
					$('#txtXspec').val($('#combSpec').find("option:selected").text());
				});
                
                if(window.parent.q_name == 'z_cubp_vu'){
                	var t_report=q_getHref()[1];
                	var t_noa=q_getHref()[3];
					var click_report=999;
					for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
						if($('#q_report').data().info.reportData[i].report==t_report){
							click_report=i;
							$('#q_report div div .radio').eq(click_report).removeClass('nonselect').addClass('select').click();
						}
					}
					$('#txtXnoa1').val(t_noa);
                    $('#txtXnoa2').val(t_noa);
                    if(t_noa.length>0){
                    	$('#btnOk').click();
                    }
				}
                
			}
            function q_boxClose(s2) {
            }
            var t_spec='@';
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'spec':
                		var as = _q_appendData("spec", "", true);
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
                		q_gf('', 'z_cucp_vu');
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
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
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