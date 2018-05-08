<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
			this.errorHandler = null;
			function onPageError(error) {
				alert("An error occurred:\r\n" + error.Message);
			}

			q_desc = 1;
			q_tables = 's';
			var q_name = "cont";
			var q_readonly = ['txtContract','txtWorker', 'txtWorker2','txtComp', 'txtAcomp','txtOrdeweight','txtGweight','txtEweight','txtTotal'];
			var q_readonlys = ['txtNoq'];
			var bbmNum = [];
			var bbsNum = [];
			var bbmMask = [];
			var bbsMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwCount2 = 9;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';
			aPop = new Array(
				['txtTggno', 'lblTgg', 'tgg', 'noa,comp,nick', 'txtTggno,txtComp,txtNick', 'tgg_b.aspx'],
				['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx'],
				['txtProductno_', 'btnProductno_', 'ucaucc', 'noa,product,unit,spec', 'txtProductno_,txtProduct_,txtUnit_,txtSpec_,txtUcolor_', 'ucaucc_b.aspx']
			);
			
			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
				q_gt('acomp', 'stop=1 ', 0, 0, 0, "cno_acomp");
				q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
				q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				//q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}

			function sum() {
				var t1 = 0, t_unit, t_mount=0, t_weight = 0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_unit = trim($('#txtUnit_' + j).val());
					if (t_unit.length == 0 || t_unit == 'KG' || t_unit == 'M2' || t_unit == 'M' || t_unit == '批' || t_unit == '公斤' || t_unit == '噸' || t_unit == '頓' || t_unit == 'T') {
						t_mount = $('#txtWeight_' + j).val();
					}else{
						t_mount = $('#txtMount_' + j).val();
					}
					$('#txtTotal_' + j).val(round(q_mul(dec($('#txtPrice_' + j).val()), dec(t_mount)), 0));//小計	
					t_weight = t_weight + dec( $('#txtWeight_' + j).val()) ; // 重量合計
					t1 = q_add(t1, dec($('#txtTotal_' + j).val()));//金額合計
				}
				
				$('#txtTotal').val(round(t1, 0));
				$('#txtOrdeweight').val(t_weight);
				$('#txtEweight').val(t_weight-q_float('txtGweight'));
			}

			function mainPost() {
				q_getFormat();
				bbmMask = [['txtDatea', r_picd],['txtBcontdate', r_picd],['txtEcontdate', r_picd]];
				q_mask(bbmMask);
				bbmNum = [['txtTotal', 15, 0, 1],['txtOrdeweight', 15, q_getPara('vcc.weightPrecision'), 1],['txtGweight', 15, q_getPara('vcc.weightPrecision'), 1],['txtEweight', 15, q_getPara('vcc.weightPrecision'), 1]];
				bbsNum = [['txtMount', 15, q_getPara('vcc.mountPrecision'), 1],['txtWeight', 15, q_getPara('vcc.weightPrecision'), 1]	,
				['txtPrice', 10, q_getPara('vcc.pricePrecision'), 1], ['txtLengthb', 15, 2, 1],['txtTotal', 15, 0, 1]];
				
				//q_cmbParse("combProduct", q_getPara('rc2s_vu.product'),'s');
				//q_cmbParse("combUcolor", q_getPara('rc2s_vu.typea'),'s');
				
				var t_where = "where=^^ 1=1 ^^";
				q_gt('ucc', t_where, 0, 0, 0, "");
				
				$('#lblNoa').text('合約號碼');
				$('#lblDatea').text('訂約日期');
				$('#lblBcontdate').text('開工日');
				$('#lblEcontdate').text('完工日');
				$('#lblOrdeweight').text('合約重量');
				$('#lblGweight').text('已完成');
				$('#lblEweight').text('合約餘量');
				$('#lblAtax').text('稅外加');
				$('#lblChka1').text('含運');
				$('#lblTotal').text('合約金額');
				$('#lblEnda').text('終止');
				$('#lblAcomp').text('簽約公司');
				document.title='進貨合約';

			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

			var focus_addr = '';
			var z_cno = r_cno, z_acomp = r_comp, z_nick = r_comp.substr(0, 2);
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'ucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc,'s');
						break;
					case 'checkContno_btnOk':
						var as = _q_appendData("cont", "", true);
                        if (as[0] != undefined) {
                            alert('合約號碼已存在!!!');
                        } else {
                            wrServer($('#txtDatea').val()+'-'+$('#txtContract').val());
                        }
						break;
					case 'bbsspec':
						var as = _q_appendData("spec", "", true);
						var t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec,'s');
						break;
					case 'bbscolor':
						var as = _q_appendData("color", "", true);
						var t_color='@';
						for ( i = 0; i < as.length; i++) {
							t_color+=","+as[i].color;
						}
						q_cmbParse("combUcolor", t_color,'s');
						break;
					case 'bbsclass':
						var as = _q_appendData("class", "", true);
						var t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						q_cmbParse("combClass", t_class,'s');
						break;
					case 'cno_acomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							z_cno = as[0].noa;
							z_acomp = as[0].acomp;
							z_nick = as[0].nick;
						}
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}

			function btnOk() {
				t_err = '';
				t_err = q_chkEmpField([['txtContract', '合約號碼'], ['txtTggno', '合約廠商'], ['txtDatea', '訂約日期']]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				$('#txtEarnest').val($('#txtPrice_0').val());
				
				//1030419 當專案沒有勾 BBM的取消和結案被打勾BBS也要寫入
				if(!$('#chkIsproj').prop('checked')){
					for (var j = 0; j < q_bbsCount; j++) {
						if($('#chkEnda').prop('checked'))
							$('#chkEnda_'+j).prop('checked','true');
					}
				}
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				if (q_cur == 2)
					$('#txtWorker2').val(r_name);
					
				sum();

				var s1 = $('#txtContract').val();
				if (s1.length == 0 || s1 == "AUTO"){
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cont') + (!emp($('#txtDatea').val())?$('#txtDatea').val():q_date()), '/', ''));
				}else{
					if (q_cur == 1){
						t_where = "where=^^ contract='" + $('#txtContract').val() + "'^^";
                    	q_gt('cont', t_where, 0, 0, 0, "checkContno_btnOk", r_accy);
					}else{
						var t_noa = $('#txtNoa').val();
						wrServer(t_noa);
					}
				}
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;

				q_box('contst_vu_s.aspx', q_name + '_s', "500px", "310px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#txtUnit_' + j).change(function() {sum();});
						$('#txtMount_' + j).change(function() {sum();});
						$('#txtWeight_' + j).change(function () {sum();});
						$('#txtPrice_' + j).change(function() {sum();});
						$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						$('#txtSize_' + j).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						$('#combProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});
					}
				}
				_bbsAssign();
				refreshBbm();
				HiddenField();
				$('#lblNoq_s').text('項次');
				$('#lblProductno_s').text('品號');
				$('#lblProduct_s').text('品名');
				$('#lblUcolor_s').text('類別');
				$('#lblSpec_s').text('材質');
				$('#lblSize_s').text('號數');
				$('#lblLengthb_s').text('米數');
				$('#lblUnit_s').text('單位');
				$('#lblMount_s').text('數量(件)');
				$('#lblWeight_s').text('重量(KG)');
				$('#lblPrice_s').text('單價');
				$('#lblTotal_s').text('小計');
				$('#lblMemo_s').text('備註');
				$('#lblEnda_s').text('終止');
				$('#vewDatea').text('訂約日期');
				$('#vewNoa').text('合約號碼');
				$('#vewComp').text('合約廠商');
			}

			function btnIns() {
				if ($('#checkCopy').is(':checked'))
					curData.copy();
				_btnIns();
				if ($('#checkCopy').is(':checked'))
					curData.paste();
				
				$('#chkIsproj').attr('checked', true);
				
				//104/08/24開放可以修改
				refreshBbm();
				
				$('#txtOdate').val(q_date());
				$('#txtDatea').val(q_date());
				
				$('#txtDatea').focus();

				$('#txtCno').val(z_cno);
				$('#txtAcomp').val(z_acomp);
				
			}

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtProduct').focus();
				
			}

			function btnPrint() {
				//q_box('z_contstp_vu.aspx' + "?;;;noa=" + trim($('#txtContract').val()) + ";" + r_accy, '', "95%", "95%", m_print);
				window.open("./z_contstp_vu.aspx"+ "?"+ r_userno + ";" + r_name + ";" + q_id +";noa=" + trim($('#txtContract').val()) + ";" + r_accy);
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {
				if (!as['product'] && !as['spec'] && !dec(as['total'])) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				as['odate'] = abbm2['odate'];
				as['tggno'] = abbm2['tggno'];
				as['apv'] = abbm2['apv'];
				return true;
			}

			function refresh(recno) {
				_refresh(recno);
				HiddenField();
				refreshBbm();
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (t_para) {
					$('#combAddr').attr('disabled', 'disabled');
				} else {
					$('#combAddr').removeAttr('disabled');
				}
			}
			
			function HiddenField(){
				var hasStyle = q_getPara('sys.isstyle');
				var isStyle = (hasStyle.toString()=='1'?$('.isStyle').show():$('.isStyle').hide());
				var hasSpec = q_getPara('sys.isspec');
				var isSpec = (hasSpec.toString()=='1'?$('.isSpec').show():$('.isSpec').hide());
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
				if (q_tables == 's')
					bbsAssign();
			}

			function q_appendData(t_Table) {
				return _q_appendData(t_Table);
			}

			function btnSeek() {
				_btnSeek();
			}

			function btnTop() {
				_btnTop();
			}

			function btnPrev() {
				_btnPrev();
			}

			function btnPrevPage() {
				_btnPrevPage();
			}

			function btnNext() {
				_btnNext();
			}

			function btnNextPage() {
				_btnNextPage();
			}

			function btnBott() {
				_btnBott();
			}

			function q_brwAssign(s1) {
				_q_brwAssign(s1);
			}

			function btnDele() {
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
			}

			function q_popPost(s1) {
				switch (s1) {
					
				}
			}
			
			function refreshBbm() {
                if (q_cur == 1) {
                    $('#txtContract').css('color', 'black').css('background', 'white').removeAttr('readonly');
                    $('#txtDatea').css('color', 'black').css('background', 'white').removeAttr('readonly');
                }else {
                    $('#txtContract').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                    $('#txtDatea').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 30%;
				border-width: 0px;
			}
			.tview {
				width: 100%;
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 70%;
				/*margin: -1px;
				 border: 1px black solid;*/
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				/*width: 10%;*/
			}
			.tbbm .tdZ {
				width: 1%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 48%;
				float: left;
			}
			.txt.c3 {
				width: 50%;
				float: left;
			}
			.txt.c4 {
				width: 25%;
				float: left;
			}
			.txt.c5 {
				width: 72%;
				float: left;
			}
			.txt.c6 {
				width: 25%;
			}
			.txt.c7 {
				width: 95%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm td input[type="button"] {
				width: auto;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.dbbs {
				width: 100%;
			}
			.tbbs a {
				font-size: medium;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			.tbbs tr.error input[type="text"] {
				color: red;
			}
			input[type="text"], input[type="button"],select {
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="overflow:hidden;width: 100%;">
			<div class="dview" id="dview">
				<table class="tview" id="tview"	>
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewNoa'> </a></td>
						<td align="center" style="width:40%"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='contract'>~contract</td>
						<td align="center" id='tggno comp,4'>~tggno ~comp,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr style="height: 1px;">
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
						<td style="width: 108px;"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td>
							<input id="txtContract" type="text" class="txt c1"/>
							<input id="txtNoa" type="hidden" class="txt c1"/>
						</td>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAcomp' class="lbl btn"> </a></td>
						<td><input id="txtCno" type="text" class="txt c1"/></td>
						<td colspan="2"><input id="txtAcomp" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTgg' class="lbl btn"> </a></td>
						<td><input id="txtTggno" type="text" class="txt c1"/></td>
						<td colspan="2">
							<input id="txtComp" type="text" class="txt c1"/>
							<input id="txtNick" type="text" class="txt c1" style="display: none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblBcontdate' class="lbl"> </a></td>
						<td><input id="txtBcontdate"	type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblEcontdate' class="lbl"> </a></td>
						<td><input id="txtEcontdate" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblOrdeweight' class="lbl"> </a></td>
						<td><input id="txtOrdeweight" type="text" class="txt num c1"></td>
						<td><span> </span><a id='lblGweight' class="lbl"> </a></td>
						<td><input id="txtGweight" type="text" class="txt num c1"></td>
						<td><span> </span><a id='lblEweight' class="lbl"> </a></td>
						<td><input id="txtEweight" type="text" class="txt num c1"></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt c1 num" /></td>
						<td><span> </span><a id='lblAtax' class="lbl"> </a></td>
						<td colspan="2">
							<input id="chkAtax" type="checkbox"/>
							<span> </span><a id='lblChka1' class="lbl" style="float: none;"> </a>
							<input id="chkChka1" type="checkbox"/>
							<span> </span><a id='lblEnda' class="lbl"  style="float: none;"> </a>
							<input id="chkEnda" type="checkbox"/>
						</td>
					</tr>
					<tr>
						<td ><span> </span><a id='lblMemo' class="lbl"> </a></td>
						<td colspan='5'>
							<!--<input id="txtMemo" type="text" style="width: 99%;"/>-->
							<textarea id="txtMemo"  rows='3' cols='3' style="width: 99%; " > </textarea>
							<input id="txtEarnest" type="hidden"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblWorker2' class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td> </td>
						<td colspan="3" style="color:red ;" >合約基價品項請設定在項序001</td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 100%;"><!--1700px-->
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn" id="btnPlus" type="button" value='＋' style="font-weight: bold;" /></td>
					<td align="center" style="width:70px;"><a id='lblNoq_s'> </a></td>
					<!--<td align="center" style="width:150px;"><a id='lblProductno_s'> </a></td>-->
					<td align="center" style="width:150px;"><a id='lblProduct_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblUcolor_s'> </a></td>
					<td align="center" style="width:150px;"><a id='lblSpec_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblSize_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblLengthb_s'> </a></td>
					<!--<td align="center" style="width:50px;"><a id='lblUnit_s'> </a></td>-->
					<td align="center" style="width:100px;"><a id='lblMount_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblWeight_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblPrice_s'> </a></td>
					<td align="center" style="width:100px;"><a id='lblTotal_s'> </a></td>
					<td align="center" style="width:200px;"><a id='lblMemo_s'> </a></td>
					<!--<td align="center" style="width:40px;"><a id='lblEnda_s'> </a></td>-->
				</tr>
				<tr style='background:#cad3ff;'>
					<td><input class="btn" id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" /></td>
					<td align="center"><input id="txtNoq.*" type="text" class="txt c1" /></td>
					<!--<td>
						<input id="txtProductno.*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno.*" type="button" value='.' style="font-weight: bold;" />
					</td>-->
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combProduct.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtUcolor.*" type="text" class="txt c1" style="width: 110px;"/>
						<select id="combUcolor.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize.*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1" /></td>
					<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtWeight.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtPrice.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtTotal.*" type="text" class="txt c1 num"/></td>
					<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
					<!--<td align="center"><input id="chkEnda.*" type="checkbox"/></td>-->
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
