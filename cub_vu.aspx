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
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            this.errorHandler = null;
            q_tables = 't';
            var q_name = "cub";
            var q_readonly = ['txtNoa'];
            var q_readonlys = ['txtOrdeno', 'txtNo2'];
            var q_readonlyt = [];
            var bbmNum = [];
            var bbsNum = [];
            var bbtNum = [];
            var bbmMask = [];
            var bbsMask = [];
            var bbtMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            q_desc = 1;
            brwCount2 = 5;
            aPop = new Array(
            	['txtProductno_', 'btnProduct_', 'ucaucc', 'noa,product', 'txtProductno_,txtProduct_', 'ucaucc_b.aspx'],
            	['txtUno__', '', 'view_uccc2', 'uno,uno,productno,product,ucolor,spec,size,lengthb,class,unit,emount,eweight'
            	, '0txtUno__,txtUno__,txtProductno__,txtProduct__,txtUcolor__,txtSpec__,txtSize__,txtLengthb__,txtClass__,txtUnit__,txtGmount__,txtGweight__', 'uccc_seek_b2.aspx?;;;1=0', '95%', '60%'],
            	['txtStoreno_', 'btnStoreno_', 'store', 'noa,store', 'txtStoreno_,txtStore_', 'store_b.aspx']
            );

            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                bbtKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
                q_gt('spec', '1=1 ', 0, 0, 0, "bbsspec");
                q_gt('color', '1=1 ', 0, 0, 0, "bbscolor");
				q_gt('class', '1=1 ', 0, 0, 0, "bbsclass");
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(0);
            }

            function sum() {
                for (var j = 0; j < q_bbsCount; j++) {
                    var t_dime = dec($('#txtDime_' + j).val());
                    $('#txtBdime_' + j).val(round(q_mul(t_dime, 0.93), 2));
                    $('#txtEdime_' + j).val(round(q_mul(t_dime, 1.07), 2));
                }
            }

            function mainPost() {
            	bbsNum = [ ['txtMount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtWeight', 9, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];//['txtPrice', 12, q_getPara('vcc.pricePrecision'), 1],
            	bbtNum = [['txtGmount', 10, q_getPara('vcc.mountPrecision'), 1], ['txtGweight', 9, q_getPara('vcc.weightPrecision'), 1], ['txtLengthb', 15, 2, 1]];
            	
                q_getFormat();
                bbmMask = [['txtDatea', r_picd], ['txtBdate', r_picd], ['txtEdate', r_picd]];
                bbsMask = [['txtDate2', r_picd], ['txtDatea', r_picd]];
                q_mask(bbmMask);
                //q_cmbParse("cmbTypea", q_getPara('cub.typea'));
                //q_cmbParse("combUcolor", q_getPara('vccs_vu.typea'),'s');
                //q_cmbParse("combUcolor", q_getPara('vccs_vu.typea'),'t');
                q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'s');
                q_cmbParse("combProduct", q_getPara('vccs_vu.product'),'t');
				
				$('#btnOrdes_vu').hide();
                $('#btnOrdes_vu').click(function() {
                    var t_bdate = trim($('#txtBdate').val());
                    var t_edate = trim($('#txtEdate').val());
                    var t_where = ' 1=1 and isnull(enda,0)!=1 and isnull(cancel,0)!=1 ';
                    t_bdate = (emp(t_bdate) ? '' : t_bdate);
                    t_edate = (emp(t_edate) ? r_picd : t_edate);
                    t_where += " and (datea between '" + t_bdate + "' and '" + t_edate + "') ";
                    t_where += " and not exists (select * from view_cubs where ordeno=view_ordes"+r_accy+".noa and no2=view_ordes"+r_accy+".no2 ) ";
                    //t_where += ' and (cut=1)';
                    q_box("ordes_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where, 'ordes', "95%", "95%", q_getMsg('popOrde'));
                });
				
				$('#btnCubu_vu').hide();
                $('#btnCubu_vu').click(function() {
                    if (q_cur == 0 || q_cur == 4) {
                        var t_where = "noa='" + trim($('#txtNoa').val()) + "'";
                        q_box("cubu_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where + ";" + r_accy, 'cubu', "95%", "95%", q_getMsg('popCubu'));
                    }
                });
                
                $('#btnCuc_vu').click(function() {
                	if (q_cur==1 || q_cur==2){
	                    var t_bdate = trim($('#txtBdate').val());
	                    var t_edate = trim($('#txtEdate').val());
	                    //訂單未結案 且 排程數量-加工數量>0
	                    var t_where = ' 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ';
	                    t_bdate = (emp(t_bdate) ? '' : t_bdate);
	                    t_edate = (emp(t_edate) ? r_picd : t_edate);
	                    t_where += " and (a.datea between '" + t_bdate + "' and '" + t_edate + "') ";
	                    t_where ="where=^^"+t_where+"^^";
	                    q_gt('cucs_vu', t_where , 0, 0, 0, "cucs_vu");
                   }
                });

                document.title = '加工單';
                $('#lblDatea').text('加工日');
                $('#lblBdate').text('排程日');
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'cucs_vu':
                		var as = _q_appendData("view_cuc", "", true);
                		for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
                			$('#btnMinus_'+j).click();
                		}
                		
                		q_gridAddRow(bbsHtm, 'tbbs'
                		, 'txtCustno,txtComp,txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtUnit,txtHmount,txtMount,txtWeight,txtMemo,txtDate2,txtOrdeno,txtNo2'
                        , as.length, as, 'acustno,acust,product,ucolor,spec,size,lengthb,class,unit,mount1,emount,eweight,memo,odatea,ordeno,no2', '','');
                	
                		break;
                	case 'bbsspec':
						var as = _q_appendData("spec", "", true);
						var t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						q_cmbParse("combSpec", t_spec,'s');
						q_cmbParse("combSpec", t_spec,'t');
						break;
					case 'bbscolor':
						var as = _q_appendData("color", "", true);
						var t_color='@';
						for ( i = 0; i < as.length; i++) {
							t_color+=","+as[i].color;
						}
						q_cmbParse("combUcolor", t_color,'s');
						q_cmbParse("combUcolor", t_color,'t');
						break;
					case 'bbsclass':
						var as = _q_appendData("class", "", true);
						var t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].class;
						}
						q_cmbParse("combClass", t_class,'s');
						q_cmbParse("combClass", t_class,'t');
						break;
                    case 'deleUccy':
                        var as = _q_appendData("uccy", "", true);
                        var err_str = '';
                        if (as[0] != undefined) {
                            for (var i = 0; i < as.length; i++) {
                                if (dec(as[i].gweight) > 0) {
                                    err_str += as[i].uno + '已領料，不能刪除!!\n';
                                }
                            }
                            if (trim(err_str).length > 0) {
                                alert(err_str);
                                return;
                            } else {
                                _btnDele();
                            }
                        } else {
                            _btnDele();
                        }
                        break;
					case 'btnOk_uccb':
						var as = _q_appendData("view_uccb", "", true);
                        if (as[0] != undefined) {
                        	var t_uno='';
                        	for ( i = 0; i < as.length; i++) {
                        		t_uno=((t_uno.length>0)?',':'')+as[i].uno;
                        	}
                            alert(t_uno+"批號已存在!!");
                        }else{
                        	check_uccb_uno=true;
                        	btnOk();
                        }
                        break;
					case 'btnOk_getuno':
						var as = _q_appendData("view_uccb", "", true);
						var maxnoq=0; 
						if(as[0] != undefined){
							maxnoq=dec(as[0].uno.slice(-3));
						}
						
						//判斷表身批號是否已被使用
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3))==$('#txtUno_'+j).val() && !emp($('#txtUno_'+j).val())){
								maxnoq=maxnoq+1;
							}
						}
						
						//寫入批號
						for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
							if(emp($('#txtUno_'+j).val()) && (!emp($('#txtProductno_'+j).val()) || !emp($('#txtProduct_'+j).val()))){
								maxnoq=maxnoq+1;
								$('#txtUno_'+j).val(replaceAll($('#txtDatea').val(),'/','')+(('000'+maxnoq).slice(-3)));
							}
						}
						
						get_maxuno=true;
						btnOk();
						break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }
            }

            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
				if(!emp($('#txtNoa').val())){
					q_func('cubu_post.post.a1', r_accy + ',' + $('#txtNoa').val() + ',0');
				}
            }
            
            function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'cubu_post.post.a1':					
						q_func('qtxt.query.cubstocubu', 'cub.txt,cubstocubu,' + encodeURI(r_accy) + ';' + encodeURI($('#txtNoa').val()));
						break;
					case 'qtxt.query.cubstocubu':
						q_func('cubu_post.post.a2', r_accy + ',' + $('#txtNoa').val() + ',1');
						break;
					case 'cubu_post.post.a2':					
						break;
				}
			}

            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case 'ordes':
                        if (q_cur > 0 && q_cur < 4) {
                            if (!b_ret || b_ret.length == 0) {
                                b_pop = '';
                                return;
                            }
                            for (var j = 0; j < b_ret.length; j++) {
                                for (var i = 0; i < q_bbtCount; i++) {
                                    var t_ordeno = $('#txtOrdeno_' + i).val();
                                    var t_no2 = $('#txtNo2_' + i).val();
                                    if (b_ret[j] && b_ret[j].noa == t_ordeno && b_ret[j].no2 == t_no2) {
                                        b_ret.splice(j, 1);
                                    }
                                }
                            }
                            if (b_ret && b_ret[0] != undefined) {
                                ret = q_gridAddRow(bbsHtm, 'tbbs', 'txtCustno,txtComp,txtProductno,txtProduct,txtUcolor,txtSpec,txtSize,txtLengthb,txtClass,txtUnit,txtOrdeno,txtNo2,txtWeight,txtMount,txtUno,txtMemo'
                                , b_ret.length, b_ret, 'custno,comp,productno,product,ucolor,spec,size,lengthb,class,unit,noa,no2,mount,weight,uno,memo', 'txtProductno');
                            }
                            sum();
                            b_ret = '';
                        }
                        break;
                    case 'uccc':
                        if (!b_ret || b_ret.length == 0) {
                            b_pop = '';
                            return;
                        }
                        if (q_cur > 0 && q_cur < 4) {
                            for (var j = 0; j < b_ret.length; j++) {
                                for (var i = 0; i < q_bbtCount; i++) {
                                    var t_uno = $('#txtUno__' + i).val();
                                    if (b_ret[j] && b_ret[j].noa == t_uno) {
                                        b_ret.splice(j, 1);
                                    }
                                }
                            }
                            if (b_ret[0] != undefined) {
                                ret = q_gridAddRow(bbtHtm, 'tbbt', 'txtUno,txtGmount,txtGweight,txtWidth,txtLengthb', b_ret.length, b_ret, 'uno,emount,eweight,width,lengthb', 'txtUno', '__');
                                /// 最後 aEmpField 不可以有【數字欄位】
                            }
                            sum();
                            b_ret = '';
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }
                b_pop = '';
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)
                    return;
				q_box('cub_vu_s.aspx', q_name + '_s', "500px", "400px", q_getMsg("popSeek"));
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtDatea').focus();
                $('#txtBdate').val(q_date());
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                $('#txtDatea').focus();
            }

            function btnPrint() {
                //q_box('z_cubp_vu.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
            }
			
			var check_uccb_uno=false;
			var get_uno=false,get_maxuno=false;
            function btnOk() {
                if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
                    alert(q_getMsg('lblDatea') + '錯誤。');
                    return;
                }
                
                //判斷批號是否已使用
				if(!check_uccb_uno){
                	var t_uno = "1=0";
                    for (var i = 0; i < q_bbsCount; i++) {
                        if ($.trim($('#txtUno_' + i).val()).length > 0)
                            t_uno += " or uno='" + $.trim($('#txtUno_' + i).val()) + "'";
                    }
					var t_where = "where=^^ ("+t_uno+") and noa!='"+$('#txtNoa').val()+"' ^^";
					q_gt('view_uccb', t_where, 0, 0, 0, "btnOk_uccb", r_accy);
					return;
                }
                
                //產生批號當天最大批號數
				//判斷是否要產生批號
				if(!get_uno){
					for (var j = 0; j < (q_bbsCount == 0 ? 1 : q_bbsCount); j++) {
						if((!emp($('#txtProductno_'+j).val()) || !emp($('#txtProduct_'+j).val()))&& emp($('#txtUno_'+j).val())){
							get_uno=true;
							break;
						}
					}
				}
				
				//預設產生批號
                if(get_uno && !get_maxuno){
	                var t_where = "where=^^ uno=isnull((select MAX(uno) from view_uccb where uno like '"+replaceAll($('#txtDatea').val(),'/','')+"%' and len(uno)=11),'')  and uno!='' ^^";
					q_gt('view_uccb', t_where, 0, 0, 0, "btnOk_getuno", r_accy);
					return;
                }
				
				check_uccb_uno=false;
				get_uno=false;
				get_maxuno=false;
                
                //檢查是否批號重複
                var uno_repeat=false;
                for (var i = 0; i < q_bbsCount; i++) {
                	if(!emp($('#txtUno_'+i).val())){
	                	for (var j = i+1; j < q_bbsCount; j++) {
	                		if($('#txtUno_'+i).val()==$('#txtUno_'+j).val()){
	                			uno_repeat=true;
	                			break;
	                		}
	                	}
                	}
                	if(uno_repeat)
                		break;
                }
                if(uno_repeat){
                	alert("批號重複!!");
                    return;
                }
                
                sum();
                $('#txtWorker').val(r_name);

                var t_noa = trim($('#txtNoa').val());
                var t_date = trim($('#txtDatea').val());
                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_cub') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
            }

            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['productno'] && !as['product'] && !as['uno'] && parseFloat(as['mount'].length == 0 ? "0" : as['mount']) == 0 && parseFloat(as['weight'].length == 0 ? "0" : as['weight']) == 0) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                as['noa'] = abbm2['noa'];
                return true;
            }

            function bbtSave(as) {
                if (!as['productno'] && !as['product'] && !as['uno']) {
                    as[bbtKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

            function refresh(recno) {
                _refresh(recno);
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
            }

            function btnMinus(id) {
                _btnMinus(id);
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function btnPlut(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#lblNo_' + i).text(i + 1);
                    if (!$('#btnMinus_' + i).hasClass('isAssign')) {
                    	$('#combUcolor_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtUcolor_'+b_seq).val($('#combUcolor_'+b_seq).find("option:selected").text());
						});
						$('#txtSize_' + i).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
                        
                        $('#btnUccc_' + i).click(function() {
                            var n = $(this).attr('id').split('_')[$(this).attr('id').split('_').length - 1];
                            var t_where = ' 1=1 and radius=0 ';
                            var t_productno = trim($('#txtProductno_' + n).val());
                            var t_bdime = dec($('#txtBdime_' + n).val());
                            var t_edime = dec($('#txtEdime_' + n).val());
                            var t_width = dec($('#txtWidth_' + n).val());
                            var t_blengthb = round(dec($('#txtLengthb_' + n).val()) * 0.88, 2);
                            var t_elengthb = round(dec($('#txtLengthb_' + n).val()) * 1.12, 2);

                            var t_array = {
                                productno : t_productno,
                                bdime : t_bdime,
                                edime : t_edime,
                                width : t_width,
                                blength : t_blengthb,
                                elength : t_elengthb
                            }

                            q_box("uccc_chk_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";;;" + encodeURIComponent(JSON.stringify(t_array)), 'uccc', "95%", "95%", q_getMsg('popUccc'));
                        });
                        
                        $('#combSpec_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtSpec_'+b_seq).val($('#combSpec_'+b_seq).find("option:selected").text());
						});
						
						$('#combClass_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtClass_'+b_seq).val($('#combClass_'+b_seq).find("option:selected").text());
						});
						
						$('#combProduct_' + i).change(function() {
							t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
							if(q_cur==1 || q_cur==2)
								$('#txtProduct_'+b_seq).val($('#combProduct_'+b_seq).find("option:selected").text());
						});

                    }
                }
                _bbsAssign();
                
                $('#lblCust_s').text('客戶');
                $('#lblProductno_s').text('品號');
                $('#lblProduct_s').text('品名');
                $('#lblUcolor_s').text('類別');
                $('#lblSpec_s').text('材質');
                $('#lblSize_s').text('號數');
                $('#lblLengthb_s').text('米數');
                $('#lblClass_s').text('廠牌');
                $('#lblUnit_s').text('單位');
                $('#lblHmount_s').text('支數');
                $('#lblMount_s').text('數量');
                $('#lblWeight_s').text('重量');
                $('#lblPrice_s').text('單價');
                $('#lblUno_s').text('批號');
                $('#lblNeed_s').text('需求');
                $('#lblMemo_s').text('備註');
                $('#lblStore_s').text('入庫倉庫');
                $('#lblDate2_s').text('交期');
                $('#lblEnda_s').text('手結');
                $('#lblOrdeno_s').text('訂單編號');
                $('#lblNo2_s').text('訂序');
                $('#lblDatea_s').text('預定出貨日期');
                $('#lblHend_s').text('過磅結案');
                
            }

            function distinct(arr1) {
                var uniArray = [];
                for (var i = 0; i < arr1.length; i++) {
                    var val = arr1[i];
                    if ($.inArray(val, uniArray) === -1) {
                        uniArray.push(val);
                    }
                }
                return uniArray;
            }

            function getBBTWhere(objname) {
                var tempArray = new Array();
                for (var j = 0; j < q_bbtCount; j++) {
                    tempArray.push($('#txt' + objname + '__' + j).val());
                }
                var TmpStr = distinct(tempArray).sort();
                TmpStr = TmpStr.toString().replace(/,/g, "','").replace(/^/, "'").replace(/$/, "'");
                return TmpStr;
            }

            function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
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
                    }
                }
                _bbtAssign();
                
                $('#lblUno_t').text('領料批號');
                $('#lblProductno_t').text('品號');
                $('#lblProduct_t').text('品名');
                $('#lblUcolor_t').text('類別');
                $('#lblSpec_t').text('材質');
                $('#lblSize_t').text('號數');
                $('#lblLengthb_t').text('米數');
                $('#lblClass_t').text('廠牌');
                $('#lblUnit_t').text('單位');
                $('#lblGmount_t').text('領料數');
                $('#lblGweight_t').text('領料重');
                $('#lblMemo2_t').text('備註');
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
                var t_where = 'where=^^ uno in(' + getBBTWhere('Uno') + ') ^^';
                q_gt('uccy', t_where, 0, 0, 0, 'deleUccy', r_accy);
            }

            function btnCancel() {
                _btnCancel();
            }

            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            function q_popPost(id) {
                switch (id) {
                    case 'txtProductno_':
                        $('#txtClass_' + b_seq).focus();
                        break;
                    default:
                        break;
                }
            }
		</script>
		<style type="text/css">
            #dmain {
                /*overflow: hidden;*/
            }
            .dview {
                float: left;
                border-width: 0px;
            }
            .tview {
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
                width: 9%;
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
                color: black;
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
                width: 95%;
                float: left;
            }

            .num {
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
            input[type="text"], input[type="button"] ,select{
                font-size: medium;
            }
            .dbbs {
                width: 100%;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                /*background: #cad3ff;*/
                background: lightgrey;
                width: 100%;
            }
            .dbbs .tbbs tr {
                height: 35px;
            }
            .dbbs .tbbs tr td {
                text-align: center;
                border: 2px lightgrey double;
            }
            .dbbs .tbbs select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
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
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain'>
			<div class="dview" id="dview" >
				<table class="tview" id="tview" >
					<tr>
						<td style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td style="width:80px; color:black;"><a id='vewNoa'> </a></td>
						<td style="width:100px; color:black;"><a id='vewDatea'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" style=''/></td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='datea' style="text-align: center;">~datea</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm" id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblDatea" class="lbl"> </a></td>
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<!--<td><span> </span><a id="lblTypea" class="lbl"> </a></td>
						<td><select id="cmbTypea" class="txt c1"> </select></td>-->
					</tr>
					<tr>
						<td><span> </span><a id="lblBdate" class="lbl" > </a></td>
						<td colspan="2">
							<input id="txtBdate" type="text" style="width:45%;"/>
							<span style="float:left; display:block; width:20px;"><a> ～ </a></span>
							<input id="txtEdate" type="text" style="width:45%;"/>
						</td>
						<!--<td> </td>-->
						<td colspan="2">
							<input type="button" id="btnCuc_vu" value="排程匯入" style="width:120px;"/>
							<input type="button" id="btnOrdes_vu" value="訂單匯入" style="width:120px;"/>
							<input type="button" id="btnCubu_vu" value="入庫" style="width:120px;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan="4"><input id="txtMemo" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
			<div class='dbbs' style="min-width: 2000px;">
				<table id="tbbs" class='tbbs'>
					<tr style='color:white; background:#003366;' >
						<td style="width:20px;"><input id="btnPlus" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
						<td style="width:20px;"> </td>
						<td style="width:100px;"><a id='lblCust_s'> </a></td>
						<!--<td style="width:150px;"><a id='lblProductno_s'> </a></td>-->
						<td style="width:150px;"><a id='lblProduct_s'> </a></td>
						<td style="width:150px;"><a id='lblUcolor_s'> </a></td>
						<td style="width:150px;"><a id='lblSpec_s'> </a></td>
						<td style="width:100px;"><a id='lblSize_s'> </a></td>
						<td style="width:100px;"><a id='lblLengthb_s'> </a></td>
						<td style="width:150px;"><a id='lblClass_s'> </a></td>
						<!--<td style="width:55px;"><a id='lblUnit_s'> </a></td>-->
						<td style="width:85px;"><a id='lblHmount_s'> </a></td>
						<td style="width:85px;"><a id='lblMount_s'> </a></td>
						<td style="width:85px;"><a id='lblWeight_s'> </a></td>
						<!--<td style="width:100px;"><a id='lblPrice_s'> </a></td>-->
						<td style="width:150px;"><a id='lblNeed_s'> </a></td>
						<td style="width:150px;"><a id='lblMemo_s'> </a></td>
						<td style="width:150px;"><a id='lblUno_s'> </a></td>
						<td style="width:100px;"><a id='lblDate2_s'> </a></td>
						<!--<td style="width:200px;"><a id='lblStore_s'> </a></td>-->
						<td style="width:30px;"><a id='lblEnda_s'> </a></td>
						<td style="width:150px;"><a id='lblOrdeno_s'> </a></td>
						<td style="width:60px;"><a id='lblNo2_s'> </a></td>
						<td style="width:100px;"><a id='lblDatea_s'> </a></td>
						<td style="width:45px;"><a id='lblHend_s'> </a></td>
					</tr>
					<tr style='background:#cad3ff;'>
						<td align="center">
							<input id="btnMinus.*" type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input id="txtNoq.*" type="text" style="display: none;"/>
							<input id="txtProductno2.*" type="hidden"/>
							<input id="txtProduct2.*" type="hidden"/>
						</td>
						<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input id="txtCustno.*" type="text" class="txt c1" style="display:none;"/>
							<input id="txtComp.*" type="text" class="txt c1"/>
						</td>
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
						<td>
							<input id="txtClass.*" type="text" class="txt c1" style="width: 70%;"/>
							<select id="combClass.*" class="txt" style="width: 20px;"> </select>
						</td>
						<!--<td><input id="txtUnit.*" type="text" class="txt c1"/></td>-->
						<td><input id="txtHmount.*" type="text" class="txt num c1"/></td>
						<td><input id="txtMount.*" type="text" class="txt num c1"/></td>
						<td><input id="txtWeight.*" type="text" class="txt num c1"/></td>
						<!--<td><input id="txtPrice.*" type="text" class="txt num c1"/></td>-->
						<td><input id="txtNeed.*" type="text" class="txt c1"/></td>
						<td><input id="txtMemo.*" type="text" class="txt c1"/></td>
						<td><input id="txtUno.*" type="text" class="txt c1"/></td>
						<td><input id="txtDate2.*" type="text" class="txt c1"/></td>
						<!--<td>
							<input id="txtStoreno.*" type="text" class="txt c1" style="width: 30%;"/>
							<input class="btn" id="btnStoreno.*" type="button" value='.' style=" font-weight: bold;float: left;" />
							<input id="txtStore.*" type="text" class="txt c1" style="width: 50%;"/>
						</td>-->
						<td><input id="chkEnda.*" type="checkbox"/></td>
						<td><input id="txtOrdeno.*" type="text" class="txt c1"/></td>
						<td><input id="txtNo2.*" type="text" class="txt c1"/></td>
						<td><input id="txtDatea.*" type="text" class="txt c1"/></td>
						<td><input id="chkHend.*" type="checkbox"/></td>
					</tr>
				</table>
			</div>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" class='dbbt'>
			<table id="tbbt" class="tbbt">
				<tr class="head" style="color:white; background:#003366;">
					<td style="width:20px;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>
					<td style="width:20px;"> </td>
					<td style="width:150px;"><a id='lblUno_t'> </a></td>
					<!--<td style="width:150px;"><a id='lblProductno_t'> </a></td>-->
					<td style="width:150px;"><a id='lblProduct_t'> </a></td>
					<td style="width:150px;"><a id='lblUcolor_t'> </a></td>
					<td style="width:150px;"><a id='lblSpec_t'> </a></td>
					<td style="width:150px;"><a id='lblSize_t'> </a></td>
					<td style="width:100px;"><a id='lblLengthb_t'> </a></td>
					<td style="width:150px;"><a id='lblClass_t'> </a></td>
					<!--<td style="width:55px;"><a id='lblUnit_t'> </a></td>-->
					<td style="width:120px;"><a id='lblGmount_t'> </a></td>
					<td style="width:120px;"><a id='lblGweight_t'> </a></td>
					<td style="width:150px; text-align: center;"><a id='lblMemo2_t'> </a></td>
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
						<input id="txtProduct..*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combProduct..*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtUcolor..*" type="text" class="txt c1" style="width: 110px;"/>
						<select id="combUcolor..*" class="txt" style="width: 20px;"> </select>
					</td>
					<td>
						<input id="txtSpec..*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combSpec..*" class="txt" style="width: 20px;"> </select>
					</td>
					<td><input id="txtSize..*" type="text" class="txt c1" /></td>
					<td><input id="txtLengthb..*" type="text" class="txt num c1" /></td>
					<td>
						<input id="txtClass..*" type="text" class="txt c1" style="width: 70%;"/>
						<select id="combClass..*" class="txt" style="width: 20px;"> </select>
					</td>
					<!--<td><input id="txtUnit..*" type="text" class="txt c1"/></td>-->
					<td><input id="txtGmount..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtGweight..*" type="text" class="txt c1 num"/></td>
					<td><input id="txtMemo2..*" type="text" class="txt c1"/></td>
				</tr>
			</table>
		</div>
	</body>
</html>