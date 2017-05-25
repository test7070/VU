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

			q_tables = 't';
			var q_name = "get";
			var q_readonly = ['txtNoa', 'txtWorker','txtWorker2','txtTranstartno','txtStoreno','txtStore'];
			var q_readonlys = [];
			var q_readonlyt = [];
			var bbmNum = [];
			var bbsNum = [];
			var bbtNum = [];
			var bbmMask = [['txtTranstart','99:99']];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Datea';

			aPop = new Array(
				['txtCustno', 'lblCustno', 'cust', 'noa,comp', 'txtCustno,txtComp', 'cust_b.aspx'],
				['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
			);

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
			}
			
			function sum() {
				var t1 = 0, t_price = 0, t_mount, t_weight = 0,t_money=0, t_tax = 0, t_total = 0;
				var tt_weight=0;
				for (var j = 0; j < q_bbsCount; j++) {
					t_weight=$('#txtWeight_' + j).val();
					/*t_price=$('#txtMweight_' + j).val();
					t_money = q_mul(dec(t_weight), dec(t_price));
					*/
					t_money=dec($('#txtLengthc_'+j).val());
					t1=q_add(t1,t_money);
					tt_weight=q_add(tt_weight,dec(t_weight));
				}
				if($('#chkAtax').prop('checked')){
					var t_taxrate = q_div(parseFloat(q_getPara('sys.taxrate')), 100);
					t_tax = round(q_mul(t1, t_taxrate), 0);
					t_total = q_add(t1, t_tax);
				}else{
					t_tax = q_float('txtTax');
					t_total = q_add(t1, t_tax);
				}
				
				t_total = q_add(t_total, dec($('#txtCartrips').val()));
				
				$('#txtMoney').val(FormatNumber(t1));
				$('#txtTax').val(FormatNumber(t_tax));
				$('#txtTotal').val(FormatNumber(t_total));
				$('#txtWeight').val(tt_weight);
			}

			function mainPost() {
				document.title='互換出貨作業';
				q_getFormat();
				bbmMask = [['txtDatea', r_picd],['txtTranstart','99:99']];
				q_mask(bbmMask);
				
				bbmNum = [['txtWeight', 15, q_getPara('vcc.weightPrecision'), 1], ['txtMoney', 15, 0, 1], ['txtTax', 15, 0, 1],['txtTotal', 15, 0, 1]
				, ['txtMount', 15, q_getPara('vcc.weightPrecision'), 1], ['txtTranstyle', 15, q_getPara('vcc.weightPrecision'), 1], ['txtTweight', 15, q_getPara('vcc.weightPrecision'), 1]
            	, ['txtPrice', 12, 3, 1], ['txtTranmoney', 15, 0, 1]]
				bbsNum = [['txtLengthb', 10, 2, 1], ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1]
				, ['txtWeight', 10, q_getPara('vcc.weightPrecision'), 1], ['txtMweight', 10, q_getPara('vcc.pricePrecision'), 1]
				, ['txtLengthc', 15, 0, 1]];
				bbtNum = [['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 9, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];
				
				q_gt('ucc', "1=1", 0, 0, 0, "bbsucc");
				q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
                q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
				
				$('#combAccount').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtAddr').val($('#combAccount').find("option:selected").text());
						$('#txtNamea').val($('#combAccount').val());
					}
				});
				
				$('#lblIdno_sf').click(function() {
					var t_where1="1=0^^";//cont
					var t_where2="where[1]=^^1=0^^";//ordhs
					var t_where3="where[2]=^^1=0^^";//quat
					var t_where4="where[3]=^^tggno='"+$('#txtCustno').val()+"' and f9>0 and isnull(enda,0)=0 order by datea,noa ^^";//ordbht
					
					q_box("cont_sf_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where1+t_where2+t_where3+t_where4, 'ordh_b', "600px", "700px", '互換合約');					
				});
				
				$('#txtIdno').change(function() {
					if(!emp($('#txtIdno').val())){
						var t_where="where=^^noa='"+$('#txtIdno').val()+"'^^ ";
						q_gt('ordh', t_where, 0, 0, 0, "hno_chage", r_accy);
					}
				});
				
				$('#txtCardealno').change(function(){
					//取得車號下拉式選單
					var thisVal = $(this).val();
					var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
					q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
				});
				
				$('#txtTweight').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtMount').val(q_sub(dec($('#txtTweight').val()),dec($('#txtTranstyle').val())));
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtTranstyle').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtMount').val(q_sub(dec($('#txtTweight').val()),dec($('#txtTranstyle').val())));
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtMount').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#txtPrice').change(function() {
					if(q_cur==1 || q_cur==2){
						$('#txtTranmoney').val(round(q_mul(dec($('#txtPrice').val()),dec($('#txtMount').val())),0))
					}
				});
				$('#chkAtax').click(function() {
					refreshBbm();
					sum();
				});
				$('#txtTax').change(function() {
					sum();
				});
				$('#txtCartrips').change(function() {
					sum();
				});
			}
			
			function q_popPost(s1) {
				switch (s1) {
					case 'txtCustno':
			   			if(!emp($('#txtCustno').val())){
			   				if(q_getPara('sys.project').toUpperCase()=='VU'){
								q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
							}else{
								q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"' and isnull(enda,0)=0  order by noq desc^^ ", 0, 0, 0, "custms");
							}
						}else{
							$('#combAccount').text('');
						}
			   			break;
			   		case 'txtCardealno':
						//取得車號下拉式選單
						var thisVal = $('#txtCardealno').val();
						var t_where = "where=^^ noa=N'" + thisVal + "' ^^";
						q_gt('cardeal', t_where, 0, 0, 0, "getCardealCarno");
						break;
				}
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'ordh_b':
                		if(q_cur > 0 && q_cur < 4) {
							b_ret = getb_ret();
							if (!b_ret || b_ret.length == 0 || b_ret[0]==undefined)
								return;
							$('#txtIdno').val(b_ret[0].noa);
						}
                		break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			
			var ordh_weight=0;
			var t_ordhno='#non';
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'getCardealCarno' :
						var as = _q_appendData("cardeals", "", true);
						carnoList = as;
						var t_item = " @ ";
						if (as[0] != undefined) {
							for ( i = 0; i < as.length; i++) {
								t_item = t_item + (t_item.length > 0 ? ',' : '') + as[i].carno + '@' + as[i].carno;
							}
						}
						for(var k=0;k<carnoList.length;k++){
							if(carnoList[k].carno==$('#txtCarno').val()){
								thisCarSpecno = carnoList[k].carspecno;
								break;
							}
						}
						document.all.combCarno.options.length = 0;
						q_cmbParse("combCarno", t_item);
						$('#combCarno').unbind('change').change(function(){
							if (q_cur == 1 || q_cur == 2) {
								$('#txtCarno').val($('#combCarno').find("option:selected").text());
							}
							for(var k=0;k<carnoList.length;k++){
								if(carnoList[k].carno==$('#txtCarno').val()){
									thisCarSpecno = carnoList[k].carspecno;
									break;
								}
							}
						});
						break;
					case 'hno_chage':
                		var as = _q_appendData("ordh", "", true);
						if (as[0] != undefined) {
							if((as[0].enda)=="true"){
								alert($('#txtIdno').val()+'互換合約已結案!');
							}else if(dec(as[0].f9)<=0){
								alert($('#txtIdno').val()+'互換合約已互換出貨完畢!');
							}else if(!emp($('#txtCustno').val()) && $('#txtCustno').val()!=as[0].custno){
								alert('互換合約廠商與互換出貨廠商不同!!');
							}else{
								$('#txtAddr').val(as[0].addr);
								if(as[0].atax=="true"){
									$('#chkAtax').prop('checked',true);
								}else{
									$('#chkAtax').prop('checked',false);
								}
								sum();
								refreshBbm();
							}
						}else{
							alert($('#txtIdno').val()+'合約不存在!!!');
						}
                		break;
                	case 'ordh_btnOk':
						var as = _q_appendData("ordh", "", true);
						if (as[0] != undefined) {
							ordh_weight=dec(as[0].f7);
							if(as[0].custno!=$('#txtCustno').val()){
								alert('互換合約廠商與互換出貨廠商不同!!');
							}else{
								var t_where = "where=^^ idno='"+$('#txtIdno').val()+"' ^^"; //and noa!='"+$('#txtNoa').val()+"'
								q_gt('view_get', t_where, 0, 0, 0, "ordh_view_get", r_accy);	
							}
						}else{
							alert($('#txtIdno').val()+'合約號碼不存在!!');
						}
						break;
					case 'ordh_view_get':
						var as = _q_appendData("view_get", "", true);
						for ( i = 0; i < as.length; i++) {
							if(as[i].noa!=$('#txtNoa').val()){
								ordh_weight=q_sub(ordh_weight,dec(as[i].weight));
							}else{
								t_ordhno=as[i].idno;
							}
						}
						if(ordh_weight>=dec($('#txtWeight').val())){
							check_ordh=true;
							btnOk();
						}else{
							var t_err='互換合約號碼【'+$('#txtIdno').val()+'】互換合約剩餘重量'+FormatNumber(ordh_weight)+'小於互換出貨重量'+FormatNumber($('#txtWeight').val());
							alert(t_err);
						}
						ordh_weight=0;
						break;
					case 'custms':
                		var as = _q_appendData("custms", "", true);
                		var t_account='@';
                		for ( i = 0; i < as.length; i++) {
                			if(as[i].account!='')
                				t_account+=","+as[i].account;
                		}
                		$('#combAccount').text('');
                		q_cmbParse("combAccount", t_account);
                		break;
                	case 'bbsucc':
						var as = _q_appendData("ucc", "", true);
						var t_ucc='@';
						for ( i = 0; i < as.length; i++) {
							t_ucc+=","+as[i].product;
						}
						q_cmbParse("combProduct", t_ucc,'s');
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
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
				
				if(t_name.substring(0,10)=='getunovcct'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_vcct', '', true);
					if (as[0] != undefined) {
						alert('該批號已出貨!!');
						$('#btnMinut__'+n).click();
					}else{
						//105/08/12 加上判斷cub 被領料
						//var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and (weight<0 or mount<0) ^^";
						//q_gt('view_cubs', t_where, 0, 0, 0, "getunocubs_"+n);
						//106/05/23 多判斷get是否出貨
						var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and noa!='"+$('#txtNoa').val()+"' ^^";
						q_gt('view_gett', t_where, 0, 0, 0, "getunogett_"+b_seq);
					}
				}else if(t_name.substring(0,10)=='getunogett'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_gett', '', true);
					if (as[0] != undefined) {
						alert('該批號已出貨!!');
						$('#btnMinut__'+n).click();
					}else{
						//105/08/12 加上判斷cub 被領料
						var t_where = "where=^^ uno='" + $('#txtUno__' + n).val() + "' and (weight<0 or mount<0) ^^";
						q_gt('view_cubs', t_where, 0, 0, 0, "getunocubs_"+n);
					}
				}else if (t_name.substring(0,10)=='getunocubs'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_cubs', '', true);
					if (as[0] != undefined) {
						alert('該批號已被領料!!');
						$('#btnMinut__'+n).click();
					}else{
						q_gt('view_orde', "where=^^ exists( select * from view_cubs where ordeno=view_orde.noa and uno='"+$('#txtUno__'+n).val()+"' ) ^^ ", 0, 0, 0, "getordecust_"+n);
					}
				}else if (t_name.substring(0,11)=='getordecust'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_orde', '', true);
					if (as[0] != undefined) {
						if(emp($('#txtCustno').val())){
							$('#txtCustno').val(as[0].custno);
							$('#txtComp').val(as[0].comp);
							$('#txtNick').val(as[0].nick);
							$('#txtTel').val(as[0].tel);
							$('#txtFax').val(as[0].fax);
							$('#txtPaytype').val(as[0].paytype);
							$('#cmbTrantype').val(as[0].trantype);
							$('#txtPost').val(as[0].post);
							$('#txtAddr').val(as[0].addr);
							$('#txtAddr2').val(as[0].addr2);
							
							q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+n).val()+"' and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
						}else{
							if($('#txtCustno').val()!=as[0].custno){
								alert('該批號訂單客戶與出貨客戶不同!!');
								$('#btnMinut__'+b_seq).click();
							}else{
								q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+n).val()+"'  and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
							}
						}
					}else{
						q_gt('view_cubs', "where=^^uno='"+$('#txtUno__'+b_seq).val()+"'  and (weight>=0 and mount>=0) ^^ ", 0, 0, 0, "getcubsuno_"+n);
					}
					/*else{
						alert('該訂單批號不存在!!');
						$('#btnMinut__'+b_seq).click();
					}*/
				}else if (t_name.substring(0,10)=='getcubsuno'){
					var n=t_name.split('_')[1];
					var as = _q_appendData('view_cubs', '', true);
					if (as[0] != undefined) {
						$('#btnMinut__'+n).click();
						q_gridAddRow(bbtHtm, 'tbbt', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtMount,txtWeight,txtUno,txtMemo,txtOrdeno,txtNo2'
							, as.length, as, 'product,ucolor,spec,size,lengthb,class,mount,weight,uno,memo,noa,noq', 'txtUno');
						
						if(dec(n)+as.length>=q_bbtCount){
							$('#btnPlut').click();
						}
						$('#txtUno__'+q_add(dec(n),as.length)).focus().select();
						//檢查批號是否重複 已 cubsnoa和cubsnoq為主
						var t_repeat=false;
						for (var i = 0; i < q_bbtCount; i++) {
							var t_cubsnoa=$('#txtOrdeno__'+i).val();
							var t_cubsnoq=$('#txtNo2__'+i).val();
							if(t_cubsnoa.length>0){
								for (var j = i+1; j < q_bbtCount; j++) {
									if(t_cubsnoa==$('#txtOrdeno__'+j).val() &&t_cubsnoq==$('#txtNo2__'+j).val()){
										t_repeat=true;
										$('#btnMinut__'+j).click();
									}
								}
							}
						}
						if(t_repeat){
							alert('該批號重複!!');
							$('#txtUno__'+(dec(n))).focus();
						}
					}else{
						alert('無此批號!!');
						$('#btnMinut__'+n).click();
					}
					bbtsum();
				}
			}
			
			var check_ordh=false;
			function btnOk() {
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
				
				if(!check_ordh && !emp($('#txtIdno').val())){
					var t_where = "where=^^ noa='"+$('#txtIdno').val()+"'^^";
					q_gt('ordh', t_where, 0, 0, 0, "ordh_btnOk", r_accy);
					return;
				}
				
				check_ordh=false;
				t_nordhno=$('#txtIdno').val();
				
				if (q_cur == 1)
					$('#txtWorker').val(r_name);
				else
					$('#txtWorker2').val(r_name);
					
				var s1 = $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val();
				if (s1.length == 0 || s1 == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_get') + $('#txtDatea').val(), '/', ''));
				else
					wrServer(s1);
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)
					return;
				q_box('get_sf_s.aspx', q_name + '_s', "500px", "350px", q_getMsg("popSeek"));
			}

			function bbsAssign() {
				for (var j = 0; j < q_bbsCount; j++) {
                	$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#combProduct_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});
						
                    	$('#combUcolor_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						
						$('#combSpec_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						
						$('#combClass_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#txtSize_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
                        	//bbsweight(b_seq);
						});
						
						$('#txtLengthb_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
                        	//bbsweight(b_seq);
						});
						
						$('#txtMount_' + j).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
                        	//bbsweight(b_seq);
						});
						
						$('#txtWeight_' + j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_weight=$('#txtWeight_' + b_seq).val();
							var t_price=$('#txtMweight_' + b_seq).val();
							var t_money = q_mul(dec(t_weight), dec(t_price));
							$('#txtLengthc_'+b_seq).val(t_money);
							sum();
						});
						$('#txtMweight_' + j).focusout(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							var t_weight=$('#txtWeight_' + b_seq).val();
							var t_price=$('#txtMweight_' + b_seq).val();
							var t_money = q_mul(dec(t_weight), dec(t_price));
							$('#txtLengthc_'+b_seq).val(t_money);
							sum();
						});
						
						$('#txtLengthc_' + j).focusout(function() {
							sum();
						});
					}
				}
				_bbsAssign();
				refreshBbs();
				
				//1050126
				$('#btnStoreCopy').click(function() {
					if(q_cur==1 || q_cur==2){
                		if(!emp($('#txtStoreno_0').val())){
	                		for (var i = 1; i < q_bbsCount; i++) {
	                			if(emp($('#txtStoreno_'+i).val())){
	                				$('#txtStoreno_'+i).val($('#txtStoreno_0').val());
	                				$('#txtStore_'+i).val($('#txtStore_0').val());
	                			}
	                		}
                		}
                	}
				});
			}
			
			function bbsweight(n) {
            	var t_siez=replaceAll($('#txtSize_'+n).val(),'#','');
            	var t_weight=0;
            	switch(t_siez){
            		case '3': t_weight=0.560; break;
            		case '4': t_weight=0.994; break;
            		case '5': t_weight=1.560; break;
            		case '6': t_weight=2.250; break;
            		case '7': t_weight=3.040; break;
            		case '8': t_weight=3.980; break;
            		case '9': t_weight=5.080; break;
            		case '10': t_weight=6.390; break;
            		case '11': t_weight=7.900; break;
            		case '12': t_weight=9.570; break;
            		case '14': t_weight=11.40; break;
            		case '16': t_weight=15.50; break;
            		case '18': t_weight=20.20; break;
            	}
            	
            	var t_lengthb=dec($('#txtLengthb_'+n).val());
            	var t_mount=dec($('#txtMount_'+n).val());
            	
            	$('#txtWeight_'+n).val(round(q_mul(q_mul(t_weight,t_lengthb),t_mount),0));
            }
            
            function refreshBbs() {
            	if(q_cur==1 || q_cur==2){
	            	for (var i = 0; i < q_bbsCount; i++) {
	            		if($('#txtNor_'+i).val()=='1'){
	            			$('#txtStoreno_'+i).attr('disabled', 'disabled');
	            			$('#btnStoreno_'+i).attr('disabled', 'disabled');
	            			$('#txtStore_'+i).attr('disabled', 'disabled');
	            		}else{
	            			$('#txtStoreno_'+i).removeAttr('disabled');
	            			$('#btnStoreno_'+i).removeAttr('disabled');
	            			$('#txtStore_'+i).removeAttr('disabled');
	            		}
	            	}
            	}
            }
            
            function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#btnMinut__' + i).click(function() {
							setTimeout(bbtsum,10);
						});
						
						$('#txtMount__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
						
						$('#txtWeight__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
                    	
                    	$('#combUcolor__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor__'+b_seq).val($('#combUcolor__'+b_seq).find("option:selected").text());
						});
						$('#txtSize__' + i).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
						$('#combSpec__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec__'+b_seq).val($('#combSpec__'+b_seq).find("option:selected").text());
						});
						
						$('#combClass__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass__'+b_seq).val($('#combClass__'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct__' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct__'+b_seq).val($('#combProduct__'+b_seq).find("option:selected").text());
						});
						
						/*$('#txtProduct__'+i).focusin(function(e) {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							
							if(q_cur==1 || q_cur==2){
								var t_b_seq=dec(b_seq)+1;
								if(t_b_seq>=q_bbtCount){
									$('#btnPlut').click();
								}
								
								$('#txtUno__'+t_b_seq).focus();
							}
						});*/
                    }
                }
                $('#btnVccttoOrde').click(function() {
                	if(q_cur==1 || q_cur==2){
	                	/*var t_ordeno="";
	                	for (var i = 0; i < q_bbtCount; i++) {
	                		if(!emp($('#txtUno__'+i).val())){
	                			t_ordeno=t_ordeno+$('#txtUno__'+i).val()+'##';
	                		}
	                	}
	                	if(t_ordeno.length>0){
	                		//q_gt('view_ordes', "where=^^charindex(isnull(noa,'')+isnull(no2,''),'"+t_ordeno+"')>0 ^^ ", 0, 0, 0, "getordes");
	                		//104/10/27 不處理直接加總
	                		//q_gt('view_ordes', "where=^^ exists( select * from view_cubs where ordeno=view_ordes.noa and no2=view_ordes.no2 and charindex(uno,'"+t_ordeno+"')>0 ) ^^ ", 0, 0, 0, "getordes");
	                	}*/
	                	
	                	//104/1031 恢復依號數、材質、類別小計
	                	for (var i = 0; i < q_bbsCount; i++) {
			            	$('#btnMinus_'+i).click();
						}
						
						var as=[],tot_uno='';
						for (var i = 0; i < q_bbtCount; i++) {
							if(!emp($('#txtUno__'+i).val())){
								var is_exists=false;
								for (var j = 0; j < as.length; j++) {
									if(as[j].product==$('#txtProduct__'+i).val() 
									&& as[j].ucolor==$('#txtUcolor__'+i).val()
									&& as[j].spec==$('#txtSpec__'+i).val()
									&& as[j].size==$('#txtSize__'+i).val()
									){
										is_exists=true;
										if(!emp($('#txtUno__'+i).val())&& tot_uno.indexOf($('#txtUno__'+i).val())==-1){
											as[j].mount=q_add(dec(as[j].mount),1);
										}
										//as[j].mount=q_add(dec(as[j].mount),dec($('#txtMount__'+i).val()));
										as[j].weight=q_add(dec(as[j].weight),dec($('#txtWeight__'+i).val()));
									}
								}
								if(!is_exists){	
									as.push({
										product:$('#txtProduct__'+i).val(),
										ucolor:$('#txtUcolor__'+i).val(),
										spec:$('#txtSpec__'+i).val(),
										size:$('#txtSize__'+i).val(),
										lengthb:0,//$('#txtLengthb__'+i).val()
										class:$('#txtClass__'+i).val(),
										mount:$('#txtMount__'+i).val(),
										weight:$('#txtWeight__'+i).val(),
										storeno:'7000A', //106/04/11
										store:'智勝-成品', //106/04/11
										nor:'1'
									});
								}
								
								tot_uno=tot_uno+($('#txtUno__'+i).val().length>0?',':'')+$('#txtUno__'+i).val();
							}
						}
						
						as.sort(bbssort);
						
						q_gridAddRow(bbsHtm, 'tbbs', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtMount,txtWeight,txtStoreno,txtStore,txtNor'
						, as.length, as, 'product,ucolor,spec,size,lengthb,class,mount,weight,storeno,store,nor','');
						
						refreshBbs();
                	}
                });
                _bbtAssign();
                for (var i = 0; i < q_bbtCount; i++) {
                	//$('#txtProduct__' + i).unbind('focus');
                	$('#txtUno__' + i).unbind('keydown');
                	$('#txtUno__' + i).unbind('change');
                	$('#txtUno__'+i).keydown(function(e) {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						
						if((q_cur==1 || q_cur==2) && (e.which==13)){
							var t_b_seq=dec(b_seq)+1;
							if(t_b_seq>=q_bbtCount){
								$('#btnPlut').click();
								$('#txtUno__' + b_seq).change();
							}
								
							$('#txtUno__'+t_b_seq).focus();
						}
					});
					$('#txtUno__' + i).change(function() {
						t_IdSeq = -1;
						q_bodyId($(this).attr('id'));
						b_seq = t_IdSeq;
						
						if($(this).val().length>0){
							var t_where = "where=^^ uno='" + $(this).val() + "' and noa!='"+$('#txtNoa').val()+"' ^^";
							q_gt('view_vcct', t_where, 0, 0, 0, "getunovcct_"+b_seq);
						}
					});
					
                }
                $('#lblUno_t').text('領料批號');
                $('#lblProductno_t').text('品號');
                $('#lblProduct_t').text('品名');
                $('#lblUcolor_t').text('類別');
                $('#lblSpec_t').text('材質');
                $('#lblSize_t').text('號數');
                $('#lblLengthb_t').text('米數');
                $('#lblClass_t').text('廠牌');
                $('#lblUnit_t').text('單位');
                $('#lblMount_t').text('領料數');
                $('#lblWeight_t').text('領料重');
                $('#lblMemo_t').text('備註');
                
                bbtsum();
            }
            
            function bbssort(a, b) {
				if (dec(replaceAll(a.size,'#',''))< dec(replaceAll(b.size,'#','')))
					return -1;
				if (dec(replaceAll(a.size,'#',''))> dec(replaceAll(b.size,'#','')))
					return 1;
				if(a.spec< b.spec)
					return -1;
				if(a.spec> b.spec)
					return 1;
				return 0;
			}
            
            function bbtsum() {
            	var tot_mount=0,tot_weight=0,tot_uno='';
                for (var i = 0; i < q_bbtCount; i++) {
                	//105/04/07 改成批號計1件
                	if(!emp($('#txtUno__'+i).val())&& tot_uno.indexOf($('#txtUno__'+i).val())==-1){
                		tot_uno=tot_uno+($('#txtUno__'+i).val().length>0?',':'')+$('#txtUno__'+i).val();
                		tot_mount++;	
                	}
                	
	                //tot_mount=q_add(tot_mount,dec($('#txtMount__'+i).val()));
	                tot_weight=q_add(tot_weight,dec($('#txtWeight__'+i).val()));
				}
				if(tot_mount!=0)
					$('#lblTot_mount').text(FormatNumber(tot_mount));
				else
					$('#lblTot_mount').text('');
				if(tot_weight!=0)
					$('#lblTot_weight').text(FormatNumber(tot_weight));
				else
					$('#lblTot_weight').text('');
            }

			function btnIns() {
				_btnIns();
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val('AUTO');
				$('#txtDatea').val(q_date());
				$('#txtDatea').focus();
				//105/12/08空白倉庫預設A
				//$('#txtStoreno').val('A').change();
			}

			function btnModi() {
				t_ordhno=$('#txtIdno').val();
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
			}

			function btnPrint() {
				q_box('z_getp_sf.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "95%", q_getMsg("popPrint"));
			}

			function wrServer(key_value) {
				var i;
				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}
			
			var t_deleno='',t_vccno='';
			function q_stPost() {
				t_ordhno=t_ordhno.length==0?'#non':t_ordhno;
				t_deleno=t_deleno.length==0?'#non':t_deleno;
				t_nordhno=t_nordhno.length==0?'#non':t_nordhno;
				
				if(q_cur==3){
					if(t_ordhno != '#non'){
						q_func('qtxt.query.changeordhtgweight', 'ordh.txt,changeordht_sf,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(t_ordhno));
					}
					t_ordhno='#non';
					
					if(t_deleno != '#non' && t_vccno!=''){
						q_func('vcc_post.post.get2vcc30', r_accy + ',' + t_vccno + ',0');
					}
				}
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				
				if((t_nordhno != '#non' || t_ordhno != '#non')){
					q_func('qtxt.query.changeordhtgweight', 'ordh.txt,changeordht_sf,' + encodeURI(r_accy) + ';' + encodeURI(t_nordhno)+ ';' + encodeURI(t_ordhno));
				}
				t_ordhno='#non';
				t_nordhno='#non';
				
				if(!emp($('#txtNoa').val())){
					var today = new Date();
					var ttime = padL(today.getHours(), '0', 2)+':'+padL(today.getMinutes(),'0',2);
					if(q_cur==1){
						q_func('qtxt.query.get2vcc.1', 'get.txt,get2vcc_sf,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(q_getPara('sys.key_vcc'))+ ';' + encodeURI(q_date())+ ';' + encodeURI(ttime));
					}else if(q_cur==2){
						q_gt('view_get', "where=^^noa='"+$('#txtNoa').val()+"'^^ ", 0, 0, 0, "gettranstartno",r_accy,1);
						var as = _q_appendData("view_get", "", true, true);
						if (as[0] != undefined) {
							if(!emp(as[0].transtartno)){
								$('#txtTranstartno').val(as[0].transtartno);
								t_vccno=as[0].transtartno;
							}
						}
						if(t_vccno.length>0)
							q_func('vcc_post.post.get2vcc20', r_accy + ',' + t_vccno + ',0');
						else{
							q_func('qtxt.query.get2vcc.1', 'get.txt,get2vcc_sf,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(q_getPara('sys.key_vcc'))+ ';' + encodeURI(q_date())+ ';' + encodeURI(ttime));
						}
					}
				}
			}

			function bbsSave(as) {
				if (!as['product']) {
					as[bbsKey[1]] = '';
					return;
				}

				q_nowf();
				as['datea'] = abbm2['datea'];
				//as['storeno'] = abbm2['storeno'];
                //as['store'] = abbm2['store'];
				return true;
			}
			
			function bbtSave(as) {
                if (!as['product'] && !as['uno']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

			function refresh(recno) {
				_refresh(recno);
				if(!emp($('#txtCustno').val())){
                	if(q_getPara('sys.project').toUpperCase()=='VU'){
						q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"'^^ ", 0, 0, 0, "custms");
					}else{
						q_gt('custms', "where=^^noa='"+$('#txtCustno').val()+"' and isnull(enda,0)=0 order by noq desc ^^ ", 0, 0, 0, "custms");
					}
				}
			}

			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if(t_para){
                	$('#combAccount').attr('disabled', 'disabled');
                	for (var i = 0; i < q_bbsCount; i++) {
                		$('#combProduct_'+i).attr('disabled', 'disabled');
                		$('#combUcolor_'+i).attr('disabled', 'disabled');
                		$('#combSpec_'+i).attr('disabled', 'disabled');
                		$('#combClass_'+i).attr('disabled', 'disabled');
                	}
                }else{
                	$('#combAccount').removeAttr('disabled');
                	for (var i = 0; i < q_bbsCount; i++) {
                		$('#combProduct_'+i).removeAttr('disabled');
                		$('#combUcolor_'+i).removeAttr('disabled');
                		$('#combSpec_'+i).removeAttr('disabled');
                		$('#combClass_'+i).removeAttr('disabled');
                	}
                }
                refreshBbs();
			}

			function btnMinus(id) {
				_btnMinus(id);
				sum();
			}

			function btnPlus(org_htm, dest_tag, afield) {
				_btnPlus(org_htm, dest_tag, afield);
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
				t_ordhno=$('#txtIdno').val();
				t_deleno=$('#txtNoa').val();
				
				q_gt('view_get', "where=^^noa='"+$('#txtNoa').val()+"'^^ ", 0, 0, 0, "gettranstartno",r_accy,1);
				var as = _q_appendData("view_get", "", true, true);
				if (as[0] != undefined) {
					$('#txtTranstartno').val(as[0].transtartno);
					t_vccno=as[0].transtartno;
				}
				_btnDele();
			}

			function btnCancel() {
				_btnCancel();
				t_ordhno='#non';
			}
			
			function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}
			
			function refreshBbm() {
                if (q_cur == 1 || q_cur==2) {
					if($('#chkAtax').prop('checked'))
						$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
					else
						$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
                }else{
                	$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
                }
            }
			
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'changeordhtgweight':
						break;
					case 'qtxt.query.get2vcc.1':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							t_vccno=as[0].vccno;
							//vcc.post內容
							if(!emp(t_vccno)){
								$('#txtTranstartno').val(t_vccno);
								q_func('vcc_post.post.get2vcc11', r_accy + ',' + t_vccno + ',1');
							}
						}
						break;
					case 'vcc_post.post.get2vcc20':
						q_func('qtxt.query.get2vcc.2', 'get.txt,get2vcc_sf,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val())+ ';' + encodeURI(q_getPara('sys.key_vcc'))+ ';' + encodeURI(q_date())+ ';' + encodeURI(ttime));
						break;
					case 'qtxt.query.get2vcc.2':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							t_vccno=as[0].vccno;
							//vcc.post內容
							if(!emp(t_vccno)){
								$('#txtTranstartno').val(t_vccno);
								q_func('vcc_post.post.get2vcc21', r_accy + ',' + t_vccno + ',1');
							}
						}
						break;
					case 'vcc_post.post.get2vcc30':
						if(t_deleno != '#non'){							
							var today = new Date();
							var ttime = padL(today.getHours(), '0', 2)+':'+padL(today.getMinutes(),'0',2);
							q_func('qtxt.query.get2vcc.3', 'get.txt,get2vcc_sf,' + encodeURI(r_accy) + ';' + encodeURI(t_deleno)+ ';' + encodeURI(q_getPara('sys.key_vcc'))+ ';' + encodeURI(q_date())+ ';' + encodeURI(ttime));
						}
						t_deleno='#non';
						break;
					case 'qtxt.query.get2vcc.3':
						var as = _q_appendData("tmp0", "", true, true);
						if (as[0] != undefined) {
							t_vccno=as[0].vccno;
							//vcc.post內容
							if(!emp(t_vccno)){
								q_func('vcc_post.post.get2vcc31', r_accy + ',' + t_vccno + ',1');
							}
						}
						break;
				}
				t_vccno=''; 
				if(t_func.indexOf('qtxt.query.getsuno_')>-1){
					var n=t_func.split('_')[1];
                	var as = _q_appendData("tmp0", "", true, true);
                	if (as[0] != undefined) {
                		if(dec(as[0].mount)<=0 || dec(as[0].weight)<=0 ){
                			alert('批號已被領用!!');
                			$('#btnMinus_'+n).click();
                		}else{
                			$('#btnMinus_'+n).click();
							q_gridAddRow(bbsHtm, 'tbbs', 'txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtMount,txtWeight,txtUno,txtMemo'
							, as.length, as, 'product,ucolor,spec,size,lengthb,class,mount,weight,uno,memo', 'txtUno');
							if(dec(n)+as.length>=q_bbsCount){
								$('#btnPlus').click();
							}
							$('#txtUno_'+q_add(dec(n),as.length)).focus().select();
                		}
                	}else{
                		alert('無此批號!!');
                		$('#btnMinus_'+n).click();
                	}
                	sum();
				}
			}
		</script>
		<style type="text/css">
			#dmain {
				overflow: hidden;
			}
			.dview {
				float: left;
				width: 98%;
			}
			.tview {
				margin: 0;
				padding: 2px;
				border: 1px black double;
				border-spacing: 0;
				font-size: medium;
				background-color: #FFFF66;
				color: blue;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border: 1px black solid;
			}
			.dbbm {
				float: left;
				width: 98%;
				margin: -1px;
				border: 1px black solid;
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
				width: 9%;
			}
			.tbbm .tdZ {
				width: 2%;
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
				font-size: medium;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 98%;
				float: left;
			}
			.txt.c2 {
				width: 33%;
				float: left;
			}
			.txt.c3 {
				width: 66%;
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
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				font-size: medium;
			}

			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.dbbs .tbbs {
				margin: 0;
				padding: 2px;
				border: 2px lightgrey double;
				border-spacing: 1px;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.dbbs .tbbs tr {
				height: 35px;
			}
			.dbbs .tbbs tr td {
				text-align: center;
				border: 2px lightgrey double;
			}
			
			#dbbt {
                width: 100%;
            }
            #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' style="width: 1260px;">
			<div class="dview" id="dview" style="float: left; width:30%;" >
				<table class="tview" id="tview" border="1" cellpadding='2' cellspacing='0' style="background-color: #FFFF66;">
					<tr>
						<td align="center" style="width:1%"><a id='vewChk'> </a></td>
						<td align="center" style="width:25%"><a id='vewDatea'> </a></td>
						<td align="center" style="width:25%"><a id='vewCust'>客戶</a></td>
						<td align="center" style="width:48%"><a id='vewIdno_sf'>合約號碼</a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=' '/></td>
						<td align="center" id='datea'>~datea</td>
						<td align="center" id='comp,4'>~comp,4</td>
						<td align="center" id='idno'>~idno</td>
					</tr>
				</table>
			</div>
			<div class='dbbm' style="width: 70%;float:left">
				<table class="tbbm" id="tbbm" border="0" cellpadding='2' cellspacing='0'>
					<tr style="height: 1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblDatea_sf" class="lbl" >互換出貨日期</a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa_sf" class="lbl" >互換出貨單號</a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTranstart_sf" class="lbl">入廠時間</a></td>
						<td><input id="txtTranstart" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCustno" class="lbl btn" > </a></td>
						<td colspan="3">
							<input id="txtCustno" type="text" class="txt c2"/>
							<input id="txtComp" type="text" class="txt c3"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblAddr_sf" class="lbl" >交貨工地</a></td>
						<td colspan="3"><input id="txtAddr"type="text" class="txt c1" style="width: 98%;"/></td>
						<td>
							<select id="combAccount" class="txt" style="width: 20px;"> </select>
							<span> </span><a id="lblNamea_sf" class="lbl" >聯絡人</a>
						</td>
						<td><input id="txtNamea" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblTranstyle_sf" class="lbl" >空重</a></td>
						<td><input id="txtTranstyle" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblTweight_sf" class="lbl">車總重</a></td>
						<td><input id="txtTweight" type="text" class="txt num c1"/></td>
						<td><span> </span><a id="lblMount_sf" class="lbl" >淨重</a></td>
						<td><input id="txtMount" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCardeal" class="lbl btn"> </a></td>
						<td>
							<input id="txtCardealno" type="text" class="txt c2"/>
							<input id="txtCardeal" type="text" class="txt c3"/>
						</td>
						<td><span> </span><a id="lblCarno" class="lbl"> </a></td>
						<td>
							<input id="txtCarno" type="text" class="txt" style="width:75%;"/>
							<select id="combCarno" style="width: 20px;"> </select>
						</td>
						<td><span> </span><a id="lblPrice_sf" class="lbl" >應付費用單價</a></td>
						<td><input id="txtPrice" type="text" class="txt num c1" style="width: 80px;"/>/KG</td>
						<td><span> </span><a id="lblTranmoney_sf" class="lbl" >應付運費</a></td>
						<td><input id="txtTranmoney" type="text" class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMoney_sf" class="lbl">應收</a></td>
						<td><input id="txtMoney" type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblTax_sf' class="lbl">營業稅</a></td>
						<td><input id="txtTax" type="text" class="txt num c1 istax"/></td>
						<td><input id="chkAtax" type="checkbox" onchange='sum()' />
							<a id='lblTotal_sf' class="lbl istax">總計<span> </span></a>
						</td>
						<td><input id="txtTotal" type="text" class="txt num c1 istax"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan='5'>
							<textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblIdno_sf" class="lbl btn">合約號碼</a></td>
						<td><input id="txtIdno" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWeight_sf" class="lbl">合約重量</a></td>
						<td><input id="txtWeight" type="text" class="txt num c1"/></td>
						<!--<td><span> </span><a id="lblStore" class="lbl btn"> </a></td>
						<td>
							<input id="txtStoreno" type="text" class="txt c2" />
							<input id="txtStore" type="text" class="txt c3"/>
						</td>-->
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblTranstartno_sf" class="lbl">立帳單號</a></td>
						<td><input id="txtTranstartno" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div class='dbbs' style="width: 1260px;">
			<table id="tbbs" class='tbbs' border="1" cellpadding='2' cellspacing='1' >
				<tr style='color:White; background:#003366;' >
					<td align="center" style="width:40px;"><input class="btn"  id="btnPlus" type="button" value='＋' style="font-weight: bold;"  /></td>
					<td align="center" style="width:55px;">項序</td>
					<td style="width:150px; text-align: center;">品名</td>
					<td style="width:160px; text-align: center;">類別</td>
					<td style="width:150px; text-align: center;">材質</td>
					<td style="width:100px; text-align: center;">號數</td>
					<td style="width:100px; text-align: center;">米數</td>
					<td style="width:100px; text-align: center;">廠牌</td>
					<td style="width:85px; text-align: center;">數量(件)</td>
					<td style="width:85px; text-align: center;">重量kg</td>
					<td style="width:85px; text-align: center;">單價</td>
					<td style="width:100px; text-align: center;">小計</td>
					<td style="width:150px; text-align: center;">出貨倉庫<input class="btn" id="btnStoreCopy" type="button" value='≡' style="font-weight: bold;"  /></td>
					<td style="width:200px; text-align: center;">單項備註</td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td>
						<input class="btn"  id="btnMinus.*" type="button" value='－' style=" font-weight: bold;" />
						<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="txtProduct.*" type="text" class="txt c1" style="width: 90px;"/>
						<select id="combProduct.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtUcolor.*" type="text" class="txt c1" style="width: 120px;"/>
						<select id="combUcolor.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtSpec.*" type="text" class="txt c1" style="width: 83px;"/>
						<select id="combSpec.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize.*" type="text" class="txt c1"/></td>
					<td><input id="txtLengthb.*" type="text" class="txt num c1"/></td>
					<td>
						<input id="txtClass.*" type="text" class="txt c1" style="width: 60px;"/>
						<select id="combClass.*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
					<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
					<td><input id="txtMweight.*" type="text" class="txt num c1"/></td>
					<td><input id="txtLengthc.*" type="text" class="txt num c1"/></td>
					<td>
						<input id="txtStoreno.*" type="text" class="txt c1" style="width: 65%"/>
						<input class="btn"  id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;" />
						<input id="txtStore.*" type="text" class="txt c1"/>
						<input id="txtNor.*" type="hidden"/>
					</td>
					<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" class='dbbt'>
			<table id="tbbt" class="tbbt">
				<tr class="head" style="color:white; background:#003366;">
					<td style="width:20px;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
					<td style="width:20px;"> </td>
					<td style="width:200px;">
						1.<a id='lblUno_t'> </a>
						<input id="btnVccttoOrde" type="button" style="font-size: medium; font-weight: bold;" value="2.出貨明細產生"/>
					</td>
					<!--<td style="width:150px;"><a id='lblProductno_t'> </a></td>-->
					<td style="width:100px;"><a id='lblProduct_t'> </a></td>
					<td style="width:150px;"><a id='lblUcolor_t'> </a></td>
					<td style="width:130px;"><a id='lblSpec_t'> </a></td>
					<td style="width:50px;"><a id='lblSize_t'> </a></td>
					<td style="width:70px;"><a id='lblLengthb_t'> </a></td>
					<td style="width:100px;"><a id='lblClass_t'> </a></td>
					<!--<td style="width:55px;"><a id='lblUnit_t'> </a></td>-->
					<td style="width:80px;">
						<a id='lblMount_t'> </a>
						<BR><a id='lblTot_mount'> </a>
					</td>
					<td style="width:100px;">
						<a id='lblWeight_t'> </a>
						<BR><a id='lblTot_weight'> </a>
					</td>
					<td style="text-align: center;"><a id='lblMemo_t'> </a></td>
				</tr>
				<tr>
					<td>
						<input id="btnMinut..*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
						<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
					</td>
					<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input id="txtUno..*" type="text" class="txt c1"/></td>
					<!--<td>
						<input id="txtProductno..*" type="text" class="txt c1" style="width: 83%;"/>
						<input class="btn" id="btnProductno..*" type="button" value='.' style="font-weight: bold;" />
					</td>-->
					<td>
						<input id="txtProduct..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combProduct..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td>
						<input id="txtUcolor..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combUcolor..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td>
						<input id="txtSpec..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combSpec..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<td><input id="txtSize..*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb..*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass..*" type="text" class="txt c1" style="width: 90%;"/>
						<select id="combClass..*" class="txt" style="width: 20px;display: none;"> </select>
					</td>
					<!--<td><input id="txtUnit..*" type="text" class="txt c1"/></td>-->
					<td><input id="txtMount..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtWeight..*" type="text" class="txt c1 num"/></td>
					<td>
						<input id="txtMemo..*" type="text" class="txt c1"/>
						<input id="txtOrdeno..*" type="hidden"/>
						<input id="txtNo2..*" type="hidden"/>
						<input id="txtItemno..*" type="hidden"/>
						<input id="txtItem..*" type="hidden"/>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>