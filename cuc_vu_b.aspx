<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src="../script/qj2.js" type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src="../script/qj_mess.js" type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'view_cuc', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa'], as;
            //, t_where = '';
            var t_sqlname = 'cuc_vu_load';
            t_postname = q_name;
            brwCount = -1;
            brwCount2 = 0;
            var isBott = false;
            var txtfield = [], afield, t_data, t_htm;
            var i, s1;
            $(document).ready(function() {
                if (!q_paraChk())
                    return;

                main();
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainBrow(6, t_content, t_sqlname, t_postname, r_accy);
                $('#btnTop').hide();
                $('#btnPrev').hide();
                $('#btnNext').hide();
                $('#btnBott').hide();
            }

            function bbsAssign() {
                _bbsAssign();
				$('#lblNoa').text('案號');
				$('#lblCust').text('客戶');
				$('#lblMech').text('工地');
				$('#lblBdate').text('預交日');
				$('#lblSweight').text('訂單總重KG');
				$('#lblBweight').text('已完成重量KG');
                $('#lblMemo').text('備註');
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
                BACKGROUND-COLOR: #76a2fe
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
		</style>
	</head>
	<body>
		<div  id="dbbs"  >
			<table id="tbbs" class='tbbs'  border="2"  cellpadding='2' cellspacing='1' style='width:100%'  >
				<tr style='color:White; background:#003366;' >
					<td align="center"> </td>
					<td align="center"><a id='lblNoa'> </a></td>
					<td align="center"><a id='lblCust'> </a></td>
					<td align="center"><a id='lblMech'> </a></td>
					<td align="center"><a id='lblBdate'> </a></td>
					<td align="center"><a id='lblSweight'> </a></td>
					<td align="center"><a id='lblBweight'> </a></td>
					<td align="center"><a id='lblMemo'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td style="width:2%;"><input name="sel"  id="radSel.*" type="radio" /></td>
					<td style="width:12%;"><input class="txt" id="txtNoa.*" type="text" style="width:98%;" /></td>
					<td style="width:10%;"><input class="txt" id="txtCust.*" type="text" style="width:98%;" /></td>
					<td style="width:20%;"><input class="txt" id="txtMech.*" type="text" style="width:98%;" /></td>
					<td style="width:10%;"><input class="txt" id="txtBdate.*" type="text" style="width:98%;" /></td>
					<td style="width:10%;"><input class="txt" id="txtSweight.*" type="text" style="width:98%;text-align:right;" /></td>
					<td style="width:10%;"><input class="txt" id="txtBweight.*" type="text" style="width:98%;text-align:right;" /></td>
					<td>
						<input class="txt" id="txtMemo.*" type="text" style="width:98%;"/>
						<input id="recno.*" type="hidden" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/brow_ctrl.inc"-->
		</div>
	</body>
</html>