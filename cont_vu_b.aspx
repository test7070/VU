<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta http-equiv="Content-Language" content="en-us" />
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"> </script>
		<script src="../script/qj2.js" type="text/javascript"> </script>
		<script src='qset.js' type="text/javascript"> </script>
		<script src="../script/qj_mess.js" type="text/javascript"> </script>
		<script src="../script/qbox.js" type="text/javascript"> </script>
    	<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            var q_name = 'cont_sf', t_bbsTag = 'tbbs', t_content = "", afilter = [], bbsKey = ['noa'], as;
            //, t_where = '';
            var t_sqlname = 'cont_sf_load';
            t_postname = q_name;
            brwCount = -1;
            brwCount2 = 0;
            var isBott = false;
            /// 是否已按過 最後一頁
            var txtfield = [], afield, t_data, t_htm, t_bbsTag = 'tbbs';
            var i, s1;
            q_desc=1;
            $(document).ready(function() {
                main();
            });
            // end ready

            function main() {
                if(dataErr)// 載入資料錯誤
                {
                    dataErr = false;
                    return;
                }
                mainBrow(0, t_content);
            }

            function q_gtPost() {
            }

            function refresh() {
                _refresh();
                $('#lblNoa').text('合約號碼');
				$('#lblComp').text('合約客戶/廠商');
				if(window.parent.q_name=='quat'){
					$('#lblComp').text('合約客戶');
				}
				if(window.parent.q_name=='cont'){
					$('#lblComp').text('合約客戶');
				}
				$('#lblDatea').text('訂約日期');
				$('#lblPrice').text('單價');
				$('#lblAddr').text('工地');
				$('#lblEweight').text('合約餘量');
				$('#lblMemo').text('備註');
				$('#lblTypea').text('合約類型');
            }
            
            function bbsAssign() {  /// checked 
			_bbsAssign();
			
			$('#lblNoa').text('合約號碼');
			$('#lblComp').text('合約客戶/廠商');
			if(window.parent.q_name=='quat'){
				$('#lblComp').text('合約客戶');
			}
			if(window.parent.q_name=='cont'){
				$('#lblComp').text('合約客戶');
			}
			$('#lblDatea').text('訂約日期');
			$('#lblPrice').text('單價');
			$('#lblAddr').text('工地');
			$('#lblEweight').text('合約餘量');
			$('#lblMemo').text('備註');
			$('#lblTypea').text('合約類型');
		}
		</script>
		<style type="text/css">
		</style>
	</head>
	<body>
		<div  id="dbbs"  >
			<table id="tbbs"  border="2"  cellpadding='0' cellspacing='0' style='width:98%' >
				<tr>
					<th align="center" > </th>
					<th align="center" style='color:Blue;' ><a id='lblNoa'> </a></th>
					<th align="center" style='color:Blue;' ><a id='lblTypea'> </a></th>
					<th align="center" style='color:Blue;' ><a id='lblAddr'> </a></th>
					<th align="center" style='color:Blue;' ><a id='lblPrice'> </a></th>
					<th align="center" style='color:Blue;' ><a id='lblEweight'> </a></th>
					<th align="center" style='color:Blue;' ><a id='lblMemo'> </a></th>
				</tr>
				<tr>
					<td style="width:1%;"><input name="sel"  id="radSel.*" type="radio" /></td>
					<td style="width:15%;"><input class="txt" id="txtNoa.*" type="text" style="width:98%;"  readonly="readonly" /></td>		
					<td style="width:10%;"><input class="txt" id="txtTypea.*" type="text" style="width:98%;"  readonly="readonly" /></td>
					<td style="width:20%;"><input class="txt" id="txtAddr.*" type="text" style="width:98%;text-align: right;"  readonly="readonly" /></td>
					<td style="width:15%;"><input class="txt" id="txtPrice.*" type="text" style="width:98%;text-align: right;"  readonly="readonly" /></td>
					<td style="width:15%;"><input class="txt" id="txtEweight.*" type="text" style="width:98%;text-align: right;"  readonly="readonly" /></td>					
					<td style="width:24%;">
						<textarea class="txt" id="txtMemo.*" cols="10" rows="2" style="width:98%;text-align: left;"  readonly="readonly" > </textarea>
					</td>                                
				</tr>
			</table>
			<!--#include file="../inc/brow_ctrl.inc"-->
		</div>
	</body>
</html>
