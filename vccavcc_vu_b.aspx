<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'vccavcc_vu', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa'], as;
            //, t_where = '';
            var t_sqlname = 'vccavcc_vu';
            t_postname = q_name;
            brwCount = -1;
			brwCount2 = 0;
			q_bbsFit = 1;

            $(document).ready(function() {
                if(!q_paraChk())
                    return;
                main();
            });

            function main() {
                if(dataErr) {
                    dataErr = false;
                    return;
                }
                mainBrow(6, t_content, t_sqlname, t_postname, r_accy);

            }

            function mainPost() {
            	$('#btnTop').hide();
            	$('#btnPrev').hide();
            	$('#btnNext').hide();
            	$('#btnBott').hide();
            	
            	$('#btnChkAll').click(function(e){
            		for(var i=0;i<q_bbsCount;i++){
                		if($('#txtNoa_'+i).val().length>0){
                			$('#chkSel_'+i).prop('checked',true);
                		}
                	}
            	});
            	$('#btnChkAll2').click(function(e){
            		for(var i=0;i<q_bbsCount;i++){
                		if($('#txtNoa_'+i).val().length>0){
                			$('#chkSel_'+i).prop('checked',!$('#chkSel_'+i).prop('checked'));
                		}
                	}
            	});
            }

            function bbsAssign() {
                var isCheck = false;
                for(var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {    
                	$('#lblNo_' + j).text(j + 1);
                    $('#chkSel_'+j).prop('checked',$('#txtVccano_'+j).val().length>0);
                    $('#txtNoa_'+j).click(function(e){
                    	var n = $(this).attr('id').replace('txtNoa_',''); 
                    	var t_noa = $(this).val();
                    	var t_chk = $('#chkSel_'+n).prop('checked');
                    	console.log(t_chk);
                    	for(var i=0;i<q_bbsCount;i++){
                    		if(t_noa == $('#txtNoa_'+i).val()){
                    			$('#chkSel_'+i).prop('checked',!t_chk);
                    		}
                    	}
                    });
                }
                _bbsAssign();
            }

            function q_gtPost() {

            }

            function refresh() {
                _refresh();
            }


		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                background-color: #76a2fe;
            }
            tr.select input[type="text"] {
                color: red;
            }
		</style>
	</head>
	<body>
		<input id="btnChkAll" type="button" value="全選"/><input id="btnChkAll2" type="button" value="反選"/><a>滑鼠左鍵點擊出貨單號，可全選(反選)該單號所有筆數。</a>
		<div id="dbbs">
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:100%'  >
				<tr style='color:white; background:#003366;' >
					<td class="td1" align="center" style="width:25px;"> </td>
					<td class="td1" align="center" style="width:25px;">&nbsp;</td>
					<td class="td2" align="center" style="width:40px;display:none;"><a id='lblAccy'>年度</a></td>
					<td class="td2" align="center" style="width:40px;display:none;"><a id='lblTablea'>來源</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblNoa'>出貨單號</a></td>
					<td class="td3" align="center" style="width:40px;"><a id='lblNoq'>序</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblProduct'>品名</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblMount'>數量</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblWeight'>重量</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblPrice'>單價</a></td>
					<td class="td3" align="center" style="width:80px;"><a id='lblTotal'>金額</a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td>
						<input type="checkbox" id="chkSel.*"/>
						<input type="text" id="txtVccano.*" class="txt" style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td style="display:none;"><input type="text" id="txtAccy.*" class="txt" style="width:95%;"/></td>
					<td style="display:none;"><input type="text" id="txtTablea.*" class="txt" style="width:95%;"/></td>
					<td><input type="text" id="txtNoa.*" class="txt" style="width:95%;"/></td>
					<td><input type="text" id="txtNoq.*" class="txt" style="width:95%;"/></td>
					<td><input type="text" id="txtProduct.*" class="txt" style="width:95%;"/></td>
					<td><input type="text" id="txtMount.*" class="txt" style="width:95%; text-align: right;"/></td>
					<td><input type="text" id="txtWeight.*" class="txt" style="width:95%; text-align: right;"/></td>
					<td><input type="text" id="txtPrice.*" class="txt" style="width:95%; text-align: right;"/></td>
					<td><input type="text" id="txtTotal.*" class="txt" style="width:95%; text-align: right;"/></td>
				</tr>
			</table>
			<!--#include file="../inc/pop_ctrl.inc"-->
		</div>
	</body>
</html>
