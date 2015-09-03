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
			var intervalupdate;
			var chk_cucs=''; //儲存要加工的cucs資料
			
			function cucs() {
            }
            cucs.prototype = {
                data : null,
                tbCount : 10,
                tbsCount : 5,
                curPage : -1,
                totPage : 0,
                curIndex : '',
                curCaddr : null,
                load : function(){
                    var string = "<table id='cucs_table' style='width:1000px;'>";
                    string+='<tr id="cucs_header">';
                    string+='<td id="cucs_chk" align="center" style="width:20px; color:black;">鎖</td>';
                    string+='<td id="cucs_cubno" align="center" style="width:20px; color:black;display:none;">鎖定人</td>'
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
                        string+='<td id="cucs_cubno'+i+'" style="display:none;text-align: center;color:'+t_color[i%t_color.length]+'"></td>';
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
                        string+='<td id="cucs_xmount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXmount_'+i+'"  type="text" class="xmount txt c1 num" /></td>';
                        string+='<td id="cucs_xcount'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXcount_'+i+'"  type="text" class="xcount txt c1 num"/></td>';
                        string+='<td id="cucs_xweight'+i+'" style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textXweight_'+i+'"  type="text" class="xweight txt c1 num" /></td>';
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
                    
                    $('.cucs_chk').click(function(e) {
                    	var n=$(this).attr('id').replace('cucs_chk','')
                    	Lock();
                    	var t_where="where=^^  1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 and a.noa='"+$('#cucs_noa'+n).text()+"' and b.noq='"+$('#cucs_noq'+n).text()+"' ^^";
                    	//判斷是否能被鎖定或解除
                    	if($(this).prop('checked')){
							q_gt('cucs_vu', t_where, 0, 0, 0,'getcanlock_'+n, r_accy);
                    	}else{
                    		q_gt('cucs_vu', t_where, 0, 0, 0,'getcanunlock_'+n, r_accy);
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
								chk_cucs[i].xcount=$('#textXcount_'+n).val();
                        	 	break;
							}
						}
                    });
                    
                    $('.xweight').blur(function(e) {
                        var n=$(this).attr('id').replace('textXweight_','');
                        //修改暫存資料
                        for(var i =0 ;i<chk_cucs.length;i++){
							if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
								chk_cucs[i].xweight=$('#textXweight_'+n).val();
                        	 	break;
							}
						}
                    });
                    
                    $('.num').each(function() {
						$(this).keyup(function(e) {
							if(e.which>=37 && e.which<=40){return;}
							var tmp=$(this).val();
							tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
							$(this).val(tmp);
						});
					});
                },
                init : function(obj) {
					chk_cucs=new Array();
					
                    this.data = new Array();
                    if (obj[0] != undefined) {
                        for (var i in obj)
                            if (obj[i]['noa'] != undefined ){
                                this.data.push(obj[i]);
                            }
                    }
                                        
                    for(var i =0 ;i<this.data.length;i++){
                    	var cubno=this.data[i]['cubno'];
						if(cubno.length>0){
							if(cubno.split('##')[0]==r_userno){
								chk_cucs.push({
										noa : this.data[i]['noa'],
										noq : this.data[i]['noq'],
										xmount : 0,
										xcount : 0,
										xweight : 0,
										ordeno:this.data[i]['ordeno'],
										no2:this.data[i]['no2']
								});
							}
						}
                    }
                    
                    this.totPage = Math.ceil(this.data.length / this.tbCount);
                    $('#textTotPage').val(this.totPage);
                    this.sort('odatea', false);
                    
                    //--cuct---------------------------------------
					var string = "<table id='cuct_table' style='width:1000px;'>";
                    string+='<tr id="cuct_header">';
                    string+='<td id="cuct_plut" align="center" style="width:20px; color:black;"><input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/></td>';
                    string+='<td id="cuct_product" align="center" style="width:100px; color:black;">品名</td>';
                    string+='<td id="cuct_ucolor" align="center" style="width:150px; color:black;">類別</td>';
                    string+='<td id="cuct_spec" align="center" style="width:110px; color:black;">材質</td>';
                    string+='<td id="cuct_size" align="center" style="width:70px; color:black;">號數</td>';
                    string+='<td id="cuct_lengthb" align="center" style="width:80px; color:black;">米數</td>';
                    string+='<td id="cuct_class" align="center" style="width:100px; color:black;">廠牌</td>';
                    string+='<td id="cuct_gmount" align="center" style="width:80px; color:black;">領料件數</td>';
                    string+='<td id="cuct_gweight" align="center" style="width:90px; color:black;">領料重量</td>';
                    string+='<td id="cuct_avgweight" align="center" style="width:90px; color:black;">均重</td>';
                    string+='<td id="cuct_memo" align="center" style="width:120px; color:black;">備註</td>';
                    string+='</tr>';
                    
                    t_color = ['DarkBlue','DarkRed'];
                    for(var i=0;i<this.tbsCount;i++){
                        string+='<tr id="cuct_tr'+i+'">';
                        string+='<td style="text-align: center;"><input id="btnMinut_'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct_'+i+'"  type="text" class="txt c3" /><select id="combProduct_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor_'+i+'"  type="text" class="txt c3" style="width:110px;"" /><select id="combUcolor_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec_'+i+'"  type="text" class="txt c3" /><select id="combSpec_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize_'+i+'"  type="text" class="txt c1 sizea" /></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb_'+i+'"  type="text" class="txt num c1" /></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass_'+i+'"  type="text" class="txt c3" /><select id="combClass_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGmount_'+i+'"  type="text" class="txt num c1" /></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGweight_'+i+'"  type="text" class="txt num c1" /></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textAvgweight_'+i+'"  type="text" class="txt num c1" disabled="disabled" /></td>';
                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo_'+i+'"  type="text" class="txt c1" /></td>';
                        string+='</tr>';
                    }
                    
                    string+='</table>';
                    $('#cuct').html(string);
                    
                    $('#btnPlut').click(function() {
                    	var now_count=cucs.tbsCount;
                    	var addcount=5;//每次新增五筆
                    	
                    	t_color = ['DarkBlue','DarkRed'];
                    	var string='';
	                    for(var i=now_count;i<(now_count+addcount);i++){
	                        string+='<tr id="cuct_tr'+i+'">';
	                        string+='<td style="text-align: center;"><input id="btnMinut_'+i+'" class="minut" type="button" style="font-size: medium; font-weight: bold;" value="－"/></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textProduct_'+i+'"  type="text" class="txt c3" /><select id="combProduct_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textUcolor_'+i+'"  type="text" class="txt c3" style="width:110px;"" /><select id="combUcolor_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSpec_'+i+'"  type="text" class="txt c3" /><select id="combSpec_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textSize_'+i+'"  type="text" class="txt c1 sizea" /></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textLengthb_'+i+'"  type="text" class="txt num c1" /></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textClass_'+i+'"  type="text" class="txt c3" /><select id="combClass_'+i+'" class="txt comb" style="width: 20px;"> </select></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGmount_'+i+'"  type="text" class="txt num c1" /></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textGweight_'+i+'"  type="text" class="txt num c1" /></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textAvgweight_'+i+'"  type="text" class="txt num c1" disabled="disabled" /></td>';
	                        string+='<td style="text-align: center;color:'+t_color[i%t_color.length]+'"><input id="textMemo_'+i+'"  type="text" class="txt c1" /></td>';
	                        string+='</tr>';
	                    }
	                    $('#cuct_table').append(string);
	                    cucs.tbsCount=now_count+addcount;
                    	cucs.refresh();
                    });
                                        
                    cucs.refresh();
                    Unlock();
                    
                    intervalupdate=setInterval("cucsupdata()",1000*60);
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
                                if (a[index] > b[index])
                                    return 1;
                                if (a[index] < b[index])
                                    return -1;
                                return 0;
                            } else {
                                if (m > n)
                                    return 1;
                                if (m < n)
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
                        	var cubno=this.data[n+i]['cubno'];
                            if(cubno.length>0){
                            	if(cubno.split('##')[0]==r_userno){
                            		$('#cucs_chk' + i).removeAttr('disabled');
                            		$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', '#FF8800');
                            	}else{ //其他人已經鎖定
                            		$('#cucs_chk' + i).attr('disabled', 'disabled');
                            		$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'pink');	
                            	}
                            }else{
                            	$('#cucs_chk' + i).removeAttr('disabled');
                            	$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'pink');	
                            }
                            $('#cucs_noa' + i).html(this.data[n+i]['noa']);
                            $('#cucs_noq' + i).html(this.data[n+i]['noq']);
                            $('#cucs_cubno' + i).html(this.data[n+i]['cubno']);
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
                            $('#textXmount_'+i).val('').attr('disabled', 'disabled');
                            $('#textXcount_'+i).val('').attr('disabled', 'disabled');
                            $('#textXweight_'+i).val('').attr('disabled', 'disabled');
                            $('#cucs_custno' + i).html(this.data[n+i]['acustno']);
                            $('#cucs_cust' + i).html(this.data[n+i]['acust']);
                            $('#cucs_memo' + i).html(this.data[n+i]['memo']);
                            $('#cucs_orde' + i).html(this.data[n+i]['ordeno']+'<BR>'+this.data[n+i]['no2']);
                            
                            //text寫入
                            for(var j =0 ;j<chk_cucs.length;j++){
                            	if(chk_cucs[j].noa==$('#cucs_noa'+i).text() && chk_cucs[j].noq==$('#cucs_noq'+i).text()){
                            		$('#cucs_chk'+i).prop('checked',true).parent().parent().find('td').css('background', '#FF8800');
									$('#textXmount_'+i).val(chk_cucs[j].xmount).removeAttr('disabled');
									$('#textXcount_'+i).val(chk_cucs[j].xcount).removeAttr('disabled');
									$('#textXweight_'+i).val(chk_cucs[j].xweight).removeAttr('disabled');
									break;
								}else{
									$('#cucs_chk'+i).prop('checked',false).parent().parent().find('td').css('background', 'pink');	
								}
                            }
                        } else {
                            $('#cucs_chk' + i).attr('disabled', 'disabled').prop('checked',false).parent().parent().find('td').css('background', 'pink');
                            $('#cucs_noa' + i).html('');
                            $('#cucs_noq' + i).html('');
                            $('#cucs_cubno' + i).html('');
                            $('#cucs_odatea' + i).html('');
                            $('#cucs_ucolor' + i).html('');
                            $('#cucs_product' + i).html('');
                            $('#cucs_spec' + i).html('');
                            $('#cucs_size' + i).html('');
                            $('#cucs_lengthb' + i).html('');
                            $('#cucs_mount' + i).html('');
                            $('#cucs_weight' + i).html('');
                            $('#cucs_emount' + i).html('');
                            $('#cucs_eweight' + i).html('');
                            $('#cucs_cust' + i).html('');
                            $('#cucs_memo' + i).html('');
                            $('#cucs_orde' + i).html('');
                            $('#textXmount_'+i).val('').attr('disabled', 'disabled');
                            $('#textXcount_'+i).val('').attr('disabled', 'disabled');
                            $('#textXweight_'+i).val('').attr('disabled', 'disabled');
                        }                      
                    }
                    
                    $('.comb').each(function(index) {
						$(this).text(''); //清空資料
						//帶入選項值
						var n=$(this).attr('id').split('_')[1];
						var objname=$(this).attr('id').split('_')[0];
						if(objname=='combProduct'){
							q_cmbParse("combProduct_"+n, q_getPara('vccs_vu.product'));
						}
						if(objname=='combUcolor'){
							q_cmbParse("combUcolor_"+n, t_ucolor);
						}
						if(objname=='combSpec'){
							q_cmbParse("combSpec_"+n, t_spec);
						}
						if(objname=='combClass'){
							q_cmbParse("combClass_"+n, t_class);
						}
						if($(this).data('events')!=undefined)
							$(this).data('events')['change']=[];
						$(this).change(function() {
							var ns=$(this).attr('id').split('_')[1];
							var objnames=$(this).attr('id').split('_')[0];
							var textnames=replaceAll(objnames,'comb','text')
							$('#'+textnames+'_'+ns).val($('#'+objname+'_'+ns).find("option:selected").text());
						});
                    });
                    
                    $('.minut').each(function(index) {
						if($(this).data('events')!=undefined)
							$(this).data('events')['click']=[];
						$(this).click(function() {
							var ns=$(this).attr('id').split('_')[1];
							$('#cuct_tr'+ns+' input[type="text"]').val('');
						});
                    });
                    
                    $('#cuct_table .num').each(function() {
                    	if($(this).data('events')!=undefined){
							$(this).data('events')['keyup']=[];
							$(this).data('events')['change']=[];
							$(this).data('events')['focusin']=[];
						}
						$(this).keyup(function(e) {
							if(e.which>=37 && e.which<=40){return;}
							var tmp=$(this).val();
							tmp=tmp.match(/\d{1,}\.{0,1}\d{0,}/);
							$(this).val(tmp);
						});
						$(this).change(function() {
							var objname=$(this).attr('id').split('_')[0];
							var n=$(this).attr('id').split('_')[1];
							if(objname=='textGmount' ){
								$('#textGweight_'+n).val(round(q_mul(dec($('#textGmount_'+n).val()),dec($('#textAvgweight_'+n).val())),0))
							}
						});
						$(this).focusin(function() {
							var objname=$(this).attr('id').split('_')[0];
							var n=$(this).attr('id').split('_')[1];
							if(objname=='textGmount' || objname=='textGweight'){
								var x_product=$('#textProduct_'+n).val();
								var x_spec=$('#textSpec_'+n).val();
								var x_size=$('#textSize_'+n).val();
								var x_lengthb=$('#textLengthb_'+n).val();
								var x_class=$('#textClass_'+n).val();
								var x_edate=$('#textDatea').val();
								if((x_product.length>0 || x_spec.length>0 || x_size.length>0 || x_lengthb.length>0 || x_class.length>0) && x_edate.length>0){
									x_product=emp($('#textProduct_'+n).val())?'#non':$('#textProduct_'+n).val();
									x_spec=emp($('#textSpec_'+n).val())?'#non':$('#textSpec_'+n).val();
									x_size=emp($('#textSize_'+n).val())?'#non':$('#textSize_'+n).val();
									x_lengthb=emp($('#textLengthb_'+n).val())?'#non':$('#textLengthb_'+n).val();
									x_class=emp($('#textClass_'+n).val())?'#non':$('#textClass_'+n).val();
									x_edate=emp($('#textDatea').val())?q_date():$('#textDatea').val();
									q_func('qtxt.query.getweight_'+n, 'cuc_vu.txt,stk_vu,'+x_product+';'+x_spec+';'+x_size+';'+x_lengthb+';'+x_class+';'+x_edate+';1');
								}
							}
						});
					});
					
                    $('#cuct_table .sizea').each(function() {
                    	if($(this).data('events')!=undefined)
							$(this).data('events')['change']=[];
						$(this).change(function() {
							 if ($(this).val().substr(0, 1) != '#')
                        		$(this).val('#' + $(this).val());
						});
					});
                }
            };
            cucs = new cucs();

			$(document).ready(function() {		
				_q_boxClose();
                q_getId();
                q_gf('', q_name);
                q_gt('spec', '1=1 ', 0, 0, 0, "");
                q_gt('color', '1=1 ', 0, 0, 0, "");
				q_gt('class', '1=1 ', 0, 0, 0, "");
			});
			
			var new_where='';
			function cucsupdata() {
				q_gt('cucs_vu', new_where, 0, 0, 0,'bbb', r_accy);
				Lock();
			}
			
			var t_spec='@',t_ucolor='@',t_class='@';
			function q_gfPost() {
				q_getFormat();
                q_langShow();
                q_popAssign();
                $('#textDatea').mask(r_picd);
                $('#textDatea').val(q_date());
                q_cur=2;
                cucs.load();
				
                var t_where = "where=^^ 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ^^";
                new_where = t_where;
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
                    new_where = t_where;
                    Lock();
					q_gt('cucs_vu', t_where, 0, 0, 0,'aaa', r_accy);
                });
                
                $('#btnCancels').click(function(e) {
					q_func('qtxt.query.unlockall', 'cuc_vu.txt,unlockall,'+r_userno+';'+r_name);
                });
                
                $('#btnCub').click(function(e) {
                	t_err = q_chkEmpField([['textDatea', '加工日'],['textMechno', '機台']]);
	                if (t_err.length > 0) {
	                    alert(t_err);
	                    return;
	                }
                	
					if(chk_cucs.length==0){
						alert('無選取加工。');
					}else{
						//先取得最新的資料再判斷是否要轉加工單
						var hasbbt=false; //是否有表身資料
                    	for(var j=0;j<cucs.tbsCount;j++){
                    		var ts_product=$('#textProduct_'+j).val(),ts_ucolor=$('#textUcolor_'+j).val(),ts_spec=$('#textSpec_'+j).val();
							var ts_size=$('#textSize_'+j).val(),ts_lengthb=$('#textLengthb_'+j).val(),ts_class=$('#textClass_'+j).val();
							var ts_gmount=$('#textGmount_'+j).val(),ts_gweight=$('#textGweight_'+j).val(),ts_memo=$('#textMemo_'+j).val();
									
							if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
								!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
								hasbbt=true;
								break;
                    		}
                    	}
						
						if(!hasbbt){
							if(confirm("無領料資料是否要轉至加工單?")){
								var t_where = "where=^^ 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ^^";
								q_gt('cucs_vu', t_where, 0, 0, 0,'ccc', r_accy);
								Lock();
							}
						}else{
							if(confirm("確定轉至加工單?")){
								var t_where = "where=^^ 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ^^";
								q_gt('cucs_vu', t_where, 0, 0, 0,'ccc', r_accy);
								Lock();
							}
						}
					}
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
                    case 'ccc':
                    	var as = _q_appendData("view_cuc", "", true);
                    	if (as[0] != undefined){
                    		var t_noa='';
                    		var t_noq='';
                    		var t_xmount='';
                    		var t_xcount='';
                    		var t_xweight='';
                    		var t_err='';
                    		for (var i=0;i<chk_cucs.length;i++){
                    			var t_exists=false;
                    			for (var j=0;j<as.length;j++){
                    				if(chk_cucs[i]['noa']==as[j]['noa'] && chk_cucs[i]['noq']==as[j]['noq']){//表示加工排程單存在
                    					if(as[j]['cubno'].split('##')[0]!=r_userno){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"鎖定人員非自己本人!!";
                    					}
                    					if(dec(as[j].emount)<dec(chk_cucs[i]['xmount'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工數量大於未完工數!!";
                    					}
                    					if(dec(as[j].eweight)<dec(chk_cucs[i]['xweight'])){
                    						t_err+=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工重量大於未完工重!!";
                    					}
                    					t_exists=true;
                    					break;
                    				}
                    			}
                    			if(t_err.length>0){
                    				break;
                    			}else if(!t_exists){
                    				t_err=chk_cucs[i]['ordeno']+'-'+chk_cucs[i]['no2']+"加工排程單不存在!!";
                    				break;
                    			}else{//表示資料正常
                    				if(dec(chk_cucs[i]['xmount'])>0 || dec(chk_cucs[i]['xweight'])>0){
	                    				t_noa=t_noa+chk_cucs[i]['noa']+'^';
			                    		t_noq=t_noq+chk_cucs[i]['noq']+'^';
			                    		t_xmount=t_xmount+dec(chk_cucs[i]['xmount'])+'^';
			                    		t_xcount=t_xcount+dec(chk_cucs[i]['xcount'])+'^';
			                    		t_xweight=t_xweight+dec(chk_cucs[i]['xweight'])+'^';
		                    		}
                    			}
                    		}
                    		if(t_err.length>0){
                    			alert(t_err);
                    		}else if(t_noa.length==0 || t_noq.length==0){
                    			alert('排程加工資料無設定數量或重量。');
                    		}else{
                    			var t_datea=emp($('#textDatea').val())?'#non':$('#textDatea').val();
                    			var t_mechno=emp($('#textMechno').val())?'#non':$('#textMechno').val();
                    			var t_memo=emp($('#textMemo').val())?'#non':$('#textMemo').val();
                    			
                    			//表身資料
                    			var ts_bbt='';
                    			for(var j=0;j<cucs.tbsCount;j++){
                    				var ts_product=$('#textProduct_'+j).val();
	                    			var ts_ucolor=$('#textUcolor_'+j).val();
									var ts_spec=$('#textSpec_'+j).val();
									var ts_size=$('#textSize_'+j).val();
									var ts_lengthb=$('#textLengthb_'+j).val();
									var ts_class=$('#textClass_'+j).val();
									var ts_gmount=$('#textGmount_'+j).val();
									var ts_gweight=$('#textGweight_'+j).val();
									var ts_memo=$('#textMemo_'+j).val();
									
									if(!emp(ts_product) || !emp(ts_ucolor) || !emp(ts_spec) || !emp(ts_size) || 
										!emp(ts_lengthb) || !emp(ts_class) || !emp(ts_gmount) || !emp(ts_gweight) || !emp(ts_memo)){
										ts_bbt=ts_bbt
										+ts_product+"^@^"
										+ts_ucolor+"^@^"
										+ts_spec+"^@^"
										+ts_size+"^@^"
										+dec(ts_lengthb)+"^@^"
										+ts_class+"^@^"
										+dec(ts_gmount)+"^@^"
										+dec(ts_gweight)+"^@^"
										+ts_memo+"^@^"
										+"^#^";
                    				}
                    			}
                    			if(ts_bbt.length==0){
                    				ts_bbt='#non'
                    			}
                    			q_func('qtxt.query.cucstocub', 'cuc_vu.txt,cucstocub,'
                    			+r_accy+';'+t_datea+';'+t_mechno+';'+t_memo+';'
                    			+r_userno+';'+r_name+';'+t_noa+';'+t_noq+';'+t_xmount+';'+t_xcount+';'+t_xweight+';'+ts_bbt);
                    			clearInterval(intervalupdate);
							}
                    	}else{
                            alert('無排程單!!');
                    	}
                    	Unlock();
                    	break;
					case 'bbb':
						var as = _q_appendData("view_cuc", "", true);
                        if (as[0] != undefined)
                            cucs.data=as;
                        else{                           
                            alert('無資料。');
                        }
                        var t_curPage=cucs.curPage
                        cucs.sort(cucs.curIndex,false);
                        cucs.curPage=t_curPage;
                        cucs.totPage = Math.ceil(cucs.data.length / cucs.tbCount);
                        if(cucs.totPage<cucs.curPage)
                        	cucs.curPage=1;
                    	$('#textTotPage').val(cucs.totPage);
                    	$('#textCurPage').val(cucs.curPage);
                    	
                    	//判斷lock是否有變動
                    	for(var i =0 ;i<as.length;i++){
                    		var cubno=as[i]['cubno'];
							if(cubno.length>0){
								if(cubno.split('##')[0]==r_userno){ //自己的鎖定資料
									var t_exists=false;
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				t_exists=true;
		                    			}
		                    		}
		                    		if(!t_exists){//當不存在時新增
		                    			chk_cucs.push({
												noa : as[i]['noa'],
												noq : as[i]['noq'],
												xmount : 0,
												xcount : 0,
												xweight : 0,
												ordeno:as[i]['ordeno'],
												no2:as[i]['no2']
										});
		                    		}
		                    	}else{//他人鎖定資料
		                    		for(var j=0;j<chk_cucs.length;j++){
		                    			if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    				chk_cucs.splice(j, 1);
		                    				j--;
                        	 				break;
		                    			}
		                    		}
		                    	}
		                    }else{//無鎖定資料
		                    	for(var j=0;j<chk_cucs.length;j++){
		                    		if(as[i]['noa']==chk_cucs[j]['noa'] && as[i]['noq']==chk_cucs[j]['noq']){
		                    			chk_cucs.splice(j, 1);
		                    			j--;
                        	 			break;
		                    		}
		                    	}
		                    }
	                    }
	                                        	
                        cucs.refresh();
                        Unlock();
                        break;
					case 'spec':
						var as = _q_appendData("spec", "", true);
						t_spec='@';
						for ( i = 0; i < as.length; i++) {
							t_spec+=","+as[i].noa;
						}
						if(cucs.data!=null)
							cucs.refresh();
						break;
					case 'color':
						var as = _q_appendData("color", "", true);
						t_ucolor='@';
						for ( i = 0; i < as.length; i++) {
							t_ucolor+=","+as[i].color;
						}
						if(cucs.data!=null)
							cucs.refresh();
						break;
					case 'class':
						var as = _q_appendData("class", "", true);
						t_class='@';
						for ( i = 0; i < as.length; i++) {
							t_class+=","+as[i].noa;
						}
						if(cucs.data!=null)
							cucs.refresh();
						break;
					case q_name:
						if (q_cur == 4)
							q_Seek_gtPost();
						break;
				}
				if(t_name.indexOf("getcanlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						if(as[0].cubno!='' && as[0].cubno.split('##')[0] != r_userno){//其他人被鎖定
							alert("該筆排程已被"+as[0].cubno.split('##')[1]+"鎖定!!");
							$('#cucs_cubno'+n).text(as[0].cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'pink');	
                        	//檢查是否有暫存 並刪除暫存資料
                        	 for(var i =0 ;i<chk_cucs.length;i++){
                        	 	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	 		chk_cucs.splice(i, 1);
                        	 		break;
                        	 	}
                        	 }
                        	//關閉欄位修改
                        	$('#textXmount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXcount_'+n).val('').attr('disabled', 'disabled');
                            $('#textXweight_'+n).val('').attr('disabled', 'disabled');
						}else{//未鎖定資料
							$('#cucs_chk'+n).parent().parent().find('td').css('background', '#FF8800');
							//鎖定資料
                        	q_func('qtxt.query.lock', 'cuc_vu.txt,lock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name);
                        	$('#cucs_cubno'+n).text(r_userno+"##"+r_name);
                        	//暫存資料
                        	chk_cucs.push({
								noa : $('#cucs_noa'+n).text(),
								noq : $('#cucs_noq'+n).text(),
								xmount : $('#textXmount_'+n).val(),
								xcount : $('#textXcount_'+n).val(),
								xweight : $('#textXweight_'+n).val(),
								ordeno:$('#cucs_orde'+n).html().split('<br>')[0],
								no2:$('#cucs_orde'+n).html().split('<br>')[1]
							});
                        	//開放欄位修改
                        	$('#textXmount_'+n).removeAttr('disabled');
							$('#textXcount_'+n).removeAttr('disabled');
							$('#textXweight_'+n).removeAttr('disabled');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'pink');	
						alert('該筆排程已完工!!');
					}
					Unlock();
				}
				if(t_name.indexOf("getcanunlock_")>-1){
					var n=t_name.split('_')[1];
					var as = _q_appendData("view_cuc", "", true);
					if (as[0] != undefined){//是否有資料
						if(as[0].cubno==''){
							$('#cucs_cubno'+n).text('');
							$('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'pink');
							alert('該筆排程已被解除鎖定!!');
						}else if(as[0].cubno!='' && as[0].cubno.split('##')[0] != r_userno){//其他人被鎖定
							$('#cucs_cubno'+n).text(as[0].cubno);
							$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'pink');
							alert('該筆排程已被鎖定!!');
						}else{//自己鎖定的資料
                        	//取消鎖定資料
                            q_func('qtxt.query.unlock', 'cuc_vu.txt,unlock,'+r_accy+';'+$('#cucs_noa'+n).text()+';'+$('#cucs_noq'+n).text()+';'+r_userno+';'+r_name);
                            $('#cucs_chk'+n).prop("checked",false).parent().parent().find('td').css('background', 'pink');
						}
					}else{
						$('#cucs_chk'+n).prop("checked",false).attr('disabled', 'disabled').parent().parent().find('td').css('background', 'pink');	
						alert('該筆排程已完工!!');
					}
					//刪除暫存資料
					for(var i =0 ;i<chk_cucs.length;i++){
                    	if(chk_cucs[i].noa==$('#cucs_noa'+n).text() && chk_cucs[i].noq==$('#cucs_noq'+n).text()){
                        	chk_cucs.splice(i, 1);
                        	break;
                        }
					}
					//關閉欄位修改
					$('#textXmount_'+n).val('').attr('disabled', 'disabled');
					$('#textXcount_'+n).val('').attr('disabled', 'disabled');
					$('#textXweight_'+n).val('').attr('disabled', 'disabled');
					Unlock();	
				}
			}
			
			var func_cubno='';
			function q_funcPost(t_func, result) {
                switch(t_func) {
                	case 'qtxt.query.unlockall':
                			//畫面直接重刷
                			chk_cucs=new Array();
							q_gt('cucs_vu', new_where, 0, 0, 0,'bbb', r_accy);
							Lock();
                		break;
                	case 'qtxt.query.cucstocub':
                		var as = _q_appendData("tmp0", "", true, true);
                        if (as[0] != undefined) {
                        	func_cubno=as[0].cubno;
                        	//產生cubu
                        	q_func('qtxt.query.cubstocubu', 'cub.txt,cubstocubu,' + encodeURI(r_accy) + ';' + encodeURI(func_cubno));
                		}
                		break;
					case 'qtxt.query.cubstocubu':
						if(func_cubno.length>0){
							q_func('cub_post.post', r_accy + ',' + encodeURI(func_cubno) + ',1');
							q_func('cubu_post.post', r_accy + ',' + encodeURI(func_cubno) + ',1');
							func_cubno='';
						}
						break;
					case 'cubu_post.post':
						alert('加工單產生完畢!!');
						//重新抓取新資料
						$('#textDatea').val(q_date());
						$('#textMechno').val('');
						$('#textMech').val('');
						$('#textMemo').val('');
						
						var t_where = "where=^^ 1=1 and isnull(d.oenda,0)!=1 and isnull(d.ocancel,0)!=1 and isnull(b.weight,0)-isnull(c.cubweight,0)>0 ^^";
		                new_where = t_where;
						q_gt('cucs_vu', t_where, 0, 0, 0,'aaa', r_accy);
						break;
                }
                if(t_func.indexOf('qtxt.query.getweight_')>-1){
                	var n=t_func.split('_')[1];
                	$('#textAvgweight_'+n).focusin();
                	var as = _q_appendData("tmp0", "", true, true);
					if (as[0] != undefined) {
						var t_weight=0,t_mount=0;
						for (var i=0;i<as.length;i++){
							t_weight=q_add(t_weight,dec(as[0].weight));
							t_mount=q_add(t_mount,dec(as[0].mount));
						}
						
						$('#textAvgweight_'+n).val(round(q_div(t_weight,t_mount),3));
					}else{
						$('#textAvgweight_'+n).val(0);
					}
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
				width: 71%;
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
            
            #cuct_table {
                border: 5px solid gray;
                font-size: medium;
                background-color: white;
            }
            #cuct_table tr {
                height: 30px;
            }
            #cuct_table td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: bisque;
                color: blue;
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
		<div id="cuct" style="float:left;width:100%;"> </div>
	</body>
</html>