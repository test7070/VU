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
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"> </script>
		<script type="text/javascript">
           if (location.href.indexOf('?') < 0) {
				location.href = location.href + "?;;;;" + ((new Date()).getUTCFullYear() - 1911);
			}
            $(document).ready(function() {
            	q_getId();
                q_gf('', 'z_cucp_vu');
            });
        	
            function q_gfPost() {
				$('#q_report').q_report({
					fileName : 'z_cucp_vu',
					options : [
					{	//[1][2]
						type : '1',
						name : 'xnoa'
					}]
				});
                q_popAssign();
				q_getFormat();
				q_langShow();
				
                 if(q_getHref()[0]=='noa' &&q_getHref()[1].length>0 && q_getHref()[1]!= undefined){
					$('#txtXnoa1').val(q_getHref()[1]);
                    $('#txtXnoa2').val(q_getHref()[1]);
				}
                
                if(window.parent.q_name == 'z_cubp_vu'){
                	var t_report=q_getHref()[1];
                	var t_noa=q_getHref()[3];
					var click_report=999;
					for(var i=0;i<$('#q_report').data().info.reportData.length;i++){
						if($('#q_report').data().info.reportData[i].report==t_report){
							click_report=i;
							$('#q_report div div .radio').eq(delete_report).removeClass('nonselect').addClass('select').click();
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
            function q_gtPost(s2) {
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