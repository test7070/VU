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
            var q_name = 'view_ordes', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa', 'no2'], as;
            //, t_where = '';
            var t_sqlname = 'view_ordes_load';
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
                $('#lblProduct').text('品名');
                $('#lblSpec').text('號數');
                $('#lblLengthb').text('米數');
                $('#lblUnit').text('單位');
                $('#lblMount').text('數量');
                $('#lblWeight').text('重量');
                $('#lblPrice').text('單價');
                $('#lblNotv').text('訂單未出');
                $('#lblNoa').text('訂單號碼');
                $('#lblMemo').text('備註');
            }

            function q_gtPost() {

            }

            function refresh() {
                _refresh();
                $('#checkAllCheckbox').click(function() {
                    $('input[type=checkbox][id^=chkSel]').each(function() {
                        var t_id = $(this).attr('id').split('_')[1];
                        if (!emp($('#txtNoa_' + t_id).val()))
                            $(this).attr('checked', $('#checkAllCheckbox').is(':checked'));
                    });
                });
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
					<td align="center"><input type="checkbox" id="checkAllCheckbox"/></td>
					<td align="center"><a id='lblProduct'> </a></td>
					<td align="center"><a id='lblSpec'> </a></td>
					<td align="center"><a id='lblLengthb'> </a></td>
					<td align="center"><a id='lblUnit'> </a></td>
					<td align="center"><a id='lblMount'> </a></td>
					<td align="center"><a id='lblWeight'> </a></td>
					<td align="center"><a id='lblPrice'> </a></td>
					<td align="center"><a id='lblNotv'> </a></td>
					<td align="center"><a id='lblNoa'> </a></td>
					<td align="center"><a id='lblMemo'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td style="width:1%;" align="center"><input id="chkSel.*" type="checkbox"  /></td>
					<td style="width:15%;"><input class="txt" id="txtProduct.*" type="text" style="width:98%;" /></td>
					<td style="width:8%;"><input class="txt" id="txtSpec.*" type="text" style="width:98%;" /></td>
					<td style="width:8%;"><input class="txt" id="txtLengthb.*" type="text" style="width:98%;text-align:right;" /></td>
					<td style="width:4%;"><input class="txt" id="txtUnit.*" type="text" style="width:94%;"/></td>
					<td style="width:8%;"><input class="txt" id="txtMount.*" type="text" style="width:94%; text-align:right;"/></td>
					<td style="width:8%;"><input class="txt" id="txtWeight.*" type="text" style="width:94%; text-align:right;"/></td>
					<td style="width:8%;"><input class="txt" id="txtPrice.*" type="text" style="width:96%; text-align:right;"/></td>
					<td style="width:8%;"><input class="txt" id="txtNotv.*" type="text" style="width:96%; text-align:right;"/></td>
					<td style="width:15%;"><input class="txt" id="txtNoa.*" type="text" style="width:70%;"/>
						<input class="txt" id="txtNo2.*" type="text" style="width:25%;" />
					</td>
					<td>
						<input class="txt" id="txtMemo.*" type="text" style="width:98%;"/>
						<input class="txt" id="txtQuatno.*" type="hidden" style="width:98%;"/>
						<input class="txt" id="txtNo3.*" type="hidden" style="width:98%;"/>
						<input id="recno.*" type="hidden" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/pop_ctrl.inc"-->
		</div>
	</body>
</html>