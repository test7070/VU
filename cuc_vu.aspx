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
			var q_name = "cuc";
			aPop = new Array(
				['textMechno', '', 'mech', 'noa,mech', 'textMechno,textMech', 'mech_b.aspx']
			);
			
			var chk_cucs=''; //儲存要加工的cuc資料
			
			function cucs() {
            }
            cucs.prototype = {
                data : null,
                tbCount : 10,
                curPage : -1,
                totPage : 0,
                curIndex : '',
                curCaddr : null,
                load : function(){
                    var string = "<table id='cucs_table' style='width:1000px;'>";
                    string+='<tr id="cucs_header">';
                    string+='<td id="cucs_chk" align="center" style="width:20px; color:black;">鎖</td>';
                    string+='<td id="cucs_noa" align="center" style="width:20px; color:black;display:none;">案號</td>'
                    string+='<td id="cucs_noq" align="center" style="width:20px; color:black;display:none;">案序</td>'
                    string+='<td id="cucs_sel" align="center" style="width:20px; color:black;"></td>';
                    string+='<td id="cucs_odatea" onclick="cucs.sort(\'odatea\',false)" title="預交日" align="center" style="width:65px; color:black;">預交日</td>';
                    string+='<td id="cucs_ucolor" onclick="cucs.sort(\'ucolor\',false)" title="類別" align="center" style="width:100px; color:black;">類別</td>';
                    string+='<td id="cucs_product" onclick="cucs.sort(\'product\',false)" title="品名" align="center" style="width:100px; color:black;">品名</td>';
                    string+='<td id="cucs_spec" onclick="cucs.sort(\'spec\',false)" title="材質" align="center" style="width:100px; color:black;">材質</td>';
                    string+='<td id="cucs_size" onclick="cucs.sort(\'size\',false)" title="號數" align="center" style="width:100px; color:black;">號數</td>';
                    string+='<td id="cucs_lengthb" onclick="cucs.sort(\'lengthb\',false)" title="米數" align="center" style="width:100px; color:black;">米數</td>';
                    string+='<td id="cucs_mount" onclick="cucs.sort(\'mount\',false)" title="訂單數" align="center" style="width:100px; color:black;">訂單數</td>';
                    string+='<td id="cucs_weight" onclick="cucs.sort(\'weight\',false)" title="訂單重" align="center" style="width:130px; color:black;">訂單重</td>';
                    string+='<td id="cucs_emount" onclick="cucs.sort(\'emount\',false)" title="未完工數" align="center" style="width:100px; color:black;">未完工數</td>';
                    string+='<td id="cucs_eweight" onclick="cucs.sort(\'eweight\',false)" title="未完工重" align="center" style="width:130px; color:black;">未完工重</td>';
                    string+='<td id="cucs_xmount" title="件數" align="center" style="width:100px; color:black;">件數</td>';
                    string+='<td id="cucs_xcount" title="支數" align="center" style="width:100px; color:black;">支數</td>';
                    string+='<td id="cucs_xweight" title="重量" align="center" style="width:130px; color:black;">重量</td>';
                    string+='<td id="cucs_custno" onclick="cucs.sort(\'custno\',false)" title="客戶編號" align="center" style="width:120px; color:black;display:none;">客戶編號</td>';
                    string+='<td id="cucs_cust" onclick="cucs.sort(\'cust\',false)" title="客戶名稱" align="center" style="width:120px; color:black;display:none;">客戶名稱</td>';
                    string+='<td id="cucs_memo" onclick="cucs.sort(\'memo\',false)" title="備註" align="center" style="width:120px; color:black;">備註</td>';
                    string+='<td id="cucs_orde" onclick="cucs.sort(\'orde\',false)" title="訂單號碼" align="center" style="width:100px; color:black;">訂單號碼</td>';
                    string+='</tr>';
                    
                    var t_color = ['DarkBlue','DarkRed'];
                    for(var i=0;i<this.tbCount;i++){
                        string+='<tr id="cucs_tr'+i+'">';
                        string+='<td style="text-align: center;"><input id="cucs_chk'+i+'" class="cucs_chk" type="checkbox"/></td>';
                        string+='<td id="cucs_noa'+i+'" style="display:none;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_noq'+i+'" style="display:none;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td style="text-align: center; font-weight: bolder; color:black;">'+(i+1)+'</td>';
                        string+='<td id="cucs_odatea'+i+'" style="font-size: 14px;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_ucolor'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_product'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_spec'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_size'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_lengthb'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_mount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_weight'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_emount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_eweight'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_xmount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXmount_'+i+'"  type="text" class="xmount txt c1" /></td>';
                        string+='<td id="cucs_xcount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXcount_'+i+'"  type="text" class="xcount txt c1"/></td>';
                        string+='<td id="cucs_xweight'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXweight_'+i+'"  type="text" class="xweight txt c1" /></td>';
                        string+='<td id="cucs_custno'+i+'" style="display:none;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_cust'+i+'" style="display:none;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_memo'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='<td id="cucs_orde'+i+'" style="font-size: 12px;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
                        string+='</tr>';
                    }
                    string+='</table>';
                    
                    $('#cucs').append(string);
                    string='';
                    string+='<a>案　號</a>&nbsp;<input id="textNoa"  type="text" style="width:130px;"/>&nbsp;';
                    string+='<a>訂單編號</a>&nbsp;<input id="textOrdeno"  type="text" style="width:130px;"/>&nbsp;';
                    string+='<a>預交日</a>&nbsp;<input id="textBdate"  type="text" style="width:80px;"/><a>~</a><input id="textEdate"  type="text" style="width:80px;"/>&nbsp;';
                    string+='<input id="btncucs_refresh"  type="button" style="width:100px;" value="刷新"/><BR>';
                    string+='<input id="btncucs_previous" onclick="cucs.previous()" type="button" style="width:100px;" value="上一頁"/>';
                    string+='<input id="btncucs_next" onclick="cucs.next()" type="button" style="width:100px;" value="下一頁"/>';
                    string+='<input id="textCurPage" onchange="cucs.page(parseInt($(this).val()))" type="text" style="width:100px;text-align: right;"/>';
                    string+='<a>/</a>';
                    string+='<input id="textTotPage"  type="text" readonly="readonly" style="width:100px;color:green;"/>';
                    $('#cucs_control').append(string);
                    
                    $('#textBdate').mask(r_picd);
                    $('#textEdate').mask(r_picd);
                },
                init : function(obj) {
					
					chk_cucs=new Array();
					
                    $('.cucs_chk').click(function(e) {
                    	var n=$(this).attr('id').replace('cucs_chk','')
                        if($(this).prop('checked')){
                        	$(this).parent().parent().find('td').css('background', '#FF8800');
                        	//暫存資料
                        	chk_cucs.push({
								noa : $('#cucs_noa'+n).text(),
								noq : $('#cucs_noq'+n).text(),
								xmount : $('#textXmount_'+n).val(),
								xcount : $('#textXcount_'+n).val(),
								xweight : $('#textXweight_'+n).val()
							});
                        	//鎖定資料
                        	
                        }else{
                        	$(this).parent().parent().find('td').css('background', 'pink');	
                        	//刪除暫存資料
                        	 for(var i =0 ;i<chk_cucs.length;i++){
                        	 	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	 		chk_cucs.splice(i, 1);
                        	 		break;
                        	 	}
                        	 }
                        	//取消鎖定資料
                        }
                    });
                    
                    $('.xmount').blur(function(e) {
                        var n=$(this).attr('id').replace('textXmount_','');
                        //修改暫存資料
                        for(var i =0 ;i<chk_cucs.length;i++){
							if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
								chk_cucs[i].xmount=$('#textXmount_'+n).val();
                        	 	break;
							}
						}
                    });
                    
                    $('.xcount').blur(function(e) {
                        var n=$(this).attr('id').replace('textXcount_','');
                        //修改暫存資料
                        for(var i =0 ;i<chk_cucs.length;i++){
							if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
								chk_cucs[i].xweight=$('#textXcount_'+n).val();
                        	 	break;
							}
						}
                    });
                    
                    $('.xweight').blur(function(e) {
                        var n=$(this).attr('id').replace('textXweight_','');
                        //修改暫存資料
                        for(var i =0 ;i<chk_cucs.length;i++){
							if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
								chk_cucs[i].xcount=$('#textXweight_'+n).val();
                        	 	break;
							}
						}
                    });
                    
                    this.data = new Array();
                    if (obj[0] != undefined) {
                        for (var i in obj)
                            if (obj[i]['noa'] != undefined ){
                                this.data.push(obj[i]);
                            }
                    }
                    this.totPage = Math.ceil(this.data.length / this.tbCount);
                    $('#textTotPage').val(this.totPage);
                    this.sort('noa', false);
                    Unlock();
                },
                sort : function(index, isFloat) {
                    //排序
                    this.curIndex = index;

                    if (isFloat) {
                        this.data.sort(function(a, b) {
                            var m = parseFloat(a[cucs.curIndex] == undefined ? "0" : a[cucs.curIndex]);
                            var n = parseFloat(b[cucs.curIndex] == undefined ? "0" : b[cucs.curIndex]);
                            if (m == n) {
                                if (a[index] < b[index])
                                    return 1;
                                if (a[index] > b[index])
                                    return -1;
                                return 0;
                            } else
                                return n - m;
                        });
                    } else {
                        this.data.sort(function(a, b) {
                            var m = a[cucs.curIndex] == undefined ? "" : a[cucs.curIndex];
                            var n = b[cucs.curIndex] == undefined ? "" : b[cucs.curIndex];
                            if (m == n) {
                                if (a[index] < b[index])
                                    return 1;
                                if (a[index] > b[index])
                                    return -1;
                                return 0;
                            } else {
                                if (m < n)
                                    return 1;
                                if (m > n)
                                    return -1;
                                return 0;
                            }
                        });
                    }
                    this.page(1);
                },
                next : function() {
                    if (this.curPage == this.totPage) {
                        alert('最末頁。');
                        return;
                    }
                    this.curPage++;
                    $('#textCurPage').val(this.curPage);
                    this.refresh();
                },
                previous : function() {
                    if (this.curPage == 1) {
                        alert('最前頁。');
                        return;
                    }
                    this.curPage--;
                    $('#textCurPage').val(this.curPage);
                    this.refresh();
                },
                page : function(n) {
                    if (n <= 0 || n > this.totPage) {
                        this.curPage = 1;
                        $('#textCurPage').val(this.curPage);
                        this.refresh();
                        return;
                    }
                    this.curPage = n;
                    $('#textCurPage').val(this.curPage);
                    this.refresh();
                },
                refresh : function() {
                    //頁面更新
                    var n = (this.curPage - 1) * this.tbCount;
                    for (var i = 0; i < this.tbCount; i++) {
                        if ((n + i) < this.data.length) {
                            $('#cucs_chk' + i).removeAttr('disabled');
                            $('#cucs_noa' + i).html(this.data[n+i]['noa']);
                            $('#cucs_noq' + i).html(this.data[n+i]['noq']);
                            $('#cucs_odatea' + i).html(this.data[n+i]['odatea']);
                            $('#cucs_ucolor' + i).html(this.data[n+i]['ucolor']);
                            $('#cucs_product' + i).html(this.data[n+i]['product']);
                            $('#cucs_spec' + i).html(this.data[n+i]['spec']);
                            $('#cucs_size' + i).html(this.data[n+i]['size']);
                            $('#cucs_lengthb' + i).html(this.data[n+i]['lengthb']);
                            $('#cucs_mount' + i).html(this.data[n+i]['mount']);  
                            $('#cucs_weight' + i).html(this.data[n+i]['weight']);  
                            $('#cucs_emount' + i).html(this.data[n+i]['emount']);
                            $('#cucs_eweight' + i).html(this.data[n+i]['eweight']);
                            $('#textXmount_'+i).val('');
                            $('#textXcount_'+i).val('');
                            $('#textXweight_'+i).val('');
                            $('#cucs_custno' + i).html(this.data[n+i]['acustno']);
                            $('#cucs_cust' + i).html(this.data[n+i]['acust']);
                            $('#cucs_memo' + i).html(this.data[n+i]['memo']);
                            $('#cucs_orde' + i).html(this.data[n+i]['ordeno']+'<BR>'+this.data[n+i]['no2']);
                            
                            //text寫入
                            for(var j =0 ;j<chk_cucs.length;j++){
                            	if(chk_cucs[j].noa==$('#cucs_noa'+i).text() && chk_cucs[j].noq==$('#cucs_noq'+i).text()){
									$('#textXmount_'+i).val(chk_cucs[i].xmount);
									$('#textXcount_'+i).val(chk_cucs[i].xcount);
									$('#textXweight_'+i).val(chk_cucs[i].xweight);
									break;
								}	
                            }
                        } else {
                            $('#cucs_chk' + i).attr('disabled', 'disabled');
                            $('#cucs_noa' + i).html('');
                            $('#cucs_noq' + i).html('');
                            $('#cucs_odatea' + i).html('');
                            $('#cucs_ucolor' + i).html('');
                            $('#cucs_product' + i).html('');
                            $('#cucs_spec' + i).html('');
                            $('#cucs_size' + i).html('');
                            $('#cucs_mount' + i).html('');
                            $('#cucs_weight' + i).html('');
                            $('#cucs_emount' + i).html('');
                            $('#cucs_eweight' + i).html('');
                            $('#cucs_cust' + i).html('');
                            $('#cucs_memo' + i).html('');
                            $('#cucs_orde' + i).html('');
                            $('#textXmount_'+i).val('');
                            $('#textXcount_'+i).val('');
                            $('#textXweight_'+i).val('');
                        }
                    }
                }
            };
            cucs = new cucs();

			$(document).ready(function() {		
				_q_boxClose();
                q_getId();
                q_gf('', q_name);
			});
			
			function q_gfPost() {
				q_getFormat();
                q_langShow();
                q_popAssign();
                $('#textDatea').mask(r_picd);
                $('#textDatea').val(q_date());
                q_cur=2;
                cucs.load();
                
                 var t_where = "where=^^ 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ^^";
				q_gt('cucs_vu', t_where, 0, 0, 0,'aaa', r_accy);
                
                $('#btncucs_refresh').click(function(e) {
                    var t_where = " 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ";
                    var t_ordeno = $('#textOrdeno').val();
                    var t_noa = $('#textNoa').val();
                    var t_bdate = $('#textBdate').val();
                    var t_edate = $('#textEdate').val();
					t_bdate = t_bdate.length > 0 && t_bdate.indexOf("_") > -1 ? t_bdate.substr(0, t_bdate.indexOf("_")) : t_bdate;  /// 100.  .
					t_edate = t_edate.length > 0 && t_edate.indexOf("_") > -1 ? t_edate.substr(0, t_edate.indexOf("_")) : t_edate;  /// 100.  .
                    
                    t_where += q_sqlPara2("b.ordeno", t_ordeno)
                    + q_sqlPara2("a.noa", t_noa)+ q_sqlPara2("isnull(d.odatea,'')", t_bdate,t_edate);
                    
                    t_where="where=^^"+t_where+"^^";
                    Lock();
					q_gt('cucs_vu', t_where, 0, 0, 0,'aaa', r_accy);
                });
                
                $('#btnCancels').click(function(e) {
                   chk_cucs=new Array();
                   cucs.refresh();
                });
                
                $('#btnCub').click(function(e) {
					if(chk_vcce.length>0){
						if(confirm("確定要轉至加工單?")){
						}
					}else
						alert('無核取資料。');
                });
            }
            
            function q_gtPost(t_name) {
				switch (t_name) {
					case 'aaa':
                        var GG = _q_appendData("view_cuc", "", true);
                        if (GG[0] != undefined)
                            cucs.init(GG);
                        else{
                            Unlock();
                            alert('無資料。');
                        }
                        break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
			}
			
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	
                }
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
				width: 38%;
				float: left;
			}
			.txt.c3 {
				width: 60%;
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
			#cucs_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cucs_table tr {
                height: 30px;
            }
            #cucs_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: pink;
                color: blue;
            }
            #cucs_header td:hover{
                background : yellow;
                cursor : pointer;
            }
		</style>
	</head>
	<body>
		<div id='q_menu'> </div>
		<div id='q_acDiv'> </div>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type='button' id='btnAuthority' name='btnAuthority' style='font-size:16px;' value='權限'/>
		<BR>
		<a class="lbl">加工日</a>&nbsp;<input id="textDatea"  type="text" class="txt" style="width: 100px;"/>&nbsp;
		<a class="lbl">機　台</a>&nbsp;
			<input id="textMechno"  type="text" class="txt " style="width: 100px;"/>
			<input id="textMech"  type="text" class="txt" style="width: 100px;" disabled="disabled"/>
		<BR>
		<a class="lbl">備　註</a>&nbsp;<input id="textMemo"  type="text" class="txt" style="width: 500px;"/>
		<input type='button' id='btnCub' style='font-size:16px;' value="入庫"/>
		<input type='button' id='btnCancels' style='font-size:16px;' value="取消鎖定"/>
		<div id="cucs" style="float:left;width:100%;"> </div> 
		<div id="cucs_control" style="width:100%;"> </div> 
	</body>
</html>