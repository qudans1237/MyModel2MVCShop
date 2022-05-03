<%@ page contentType="text/html; charset=euc-kr"%>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<head>
<title></title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	
	<!--  ///////////////////////// Bootstrap, jQuery CDN ////////////////////////// -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	<script type="text/javascript">
	
	//fncGetProductList(currentPage)
	function fncGetList(currentPage) {

		$("#currentPage").val(currentPage)

		$("form").attr("method", "POST").attr("action","/product/listProduct?menu=${param.menu}").submit();
	}

	$(function() {

		$("td.ct_btn01:contains('�˻�')").on("click", function() {
			fncGetUserList(1);
		});

		$(".ct_list_pop td:nth-child(3)").on("click",function() {
					//alert(  $(this).children("input").val().trim() );
					var prodNo = $(this).children("input").val().trim();
					$.ajax({
						url : "/product/json/getProduct/" + prodNo,
						method : "GET",
						dataType : "json",
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						success : function(JSONData, status) {

							//	alert(status);
							// 	alert("JSONData : \n"+JSONData.prodNo);

							var displayValue = "<h3>" + 
							"��ǰ��ȣ : "+JSONData.prodNo + "<br/>" +
							"��� : "+ JSONData.stock + "<br/>" +
							"��ǰ�̹��� : <img src=/images/uploadFiles/"+ JSONData.fileName+ "/><br/>" 
							"</h3>";

							//alert(displayValue);
							$("h3").remove();
							$("#" + prodNo + "").html(displayValue);
						}
					});
				});

		$(".ct_list_pop td:nth-child(1)").on("click",function() {
					self.location = "/product/getProduct?prodNo="
							+ $(this).children("input").val()
							+ "&menu=${param.menu}";
				});

		$("h8:contains('����ϱ�')")
				.on(
						"click",
						function() {
							//alert($("#prodNo").val());
							self.location = "/purchase/updateTranCodeByProd?menu=manage&prodNo="
									+ $("#prodNo").val() + "&tranCode=2";
						});
		
		$(".ct_list_pop td:nth-child(3)").css("color", "#DF7401");
		$(".ct_list_pop td:nth-child(1)").css("color", "#DBA901");
		$("h8").css("color", "#FE642E");
		$(".ct_list_pop td:nth-child(9):contains('ǰ��')").css("color", "#FF0040");

		$(".ct_list_pop:nth-child(4n+6)").css("background-color", "whitesmoke");

	});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">
	<!-- ToolBar Start /////////////////////////////////////-->
	<jsp:include page="/layout/toolbar.jsp" />
   	<!-- ToolBar End /////////////////////////////////////-->
	<div style="width: 98%; margin-left: 10px;">

		<form name="detailForm">

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37" /></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="93%" class="ct_ttl01">
									<!--manage�� ��� ��ǰ���� search�ΰ�� ��ǰ�����ȸ --> <c:if
										test="${param.menu=='manage'}">
						��ǰ����
					</c:if> <c:if test="${param.menu=='search'}">
						��ǰ �����ȸ
					</c:if>
								</td>
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37" /></td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="right"><select name="searchCondition"
						class="ct_input_g" style="width: 80px">
							<option value="0"
								${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>��ǰ��ȣ</option>
							<option value="1"
								${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>��ǰ��</option>
							<option value="2"
								${ ! empty search.searchCondition && search.searchCondition==2 ? "selected" : "" }>��ǰ����</option>
					</select> <input type="text" name="searchKeyword"
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
								class="ct_input_g"
						style="width: 200px; height: 19px"></td>

					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img
									src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01"
									style="padding-top: 3px;">�˻�</td>
								<td width="14" height="23"><img
									src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>



			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td colspan="11">��ü ${resultPage.totalCount } �Ǽ�, ����
						${resultPage.currentPage } ������</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="100">No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">��ǰ��<br> <h7>(��ǰ��click:������)</h7>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">����</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">��ǰ������</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">�������</td>
					<td class="ct_line02"></td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>


				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list }">
					<c:set var="i" value="${i+1 }" />
					<tr class="ct_list_pop">
						<td align="center"><input type="hidden" name="prodNo"
							value="${product.prodNo }" />${i }</td>
						<td></td>
						<td align="left"><input type="hidden" name="prodNo"
							value="${product.prodNo }" /> ${product.prodName }</td>
						<td></td>
						<td align="left">${product.price }��</td>
						<td></td>
						<td align="left">${product.prodDetail }</td>
						<td></td>
						<td align="left"><c:if test="${product.stock!=0 }">�Ǹ���</c:if>
							<c:if
								test="${product.stock==0 && (empty user ||  empty product.proTranCode || !empty user)}">ǰ��</c:if>
						</td>
					</tr>
					<tr>
						<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6"
							height="1"></td>
					</tr>
				</c:forEach>
			</table>

			<!--  ������ Navigator ���� -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> <jsp:include
							page="../common/pageNavigator_new.jsp" /></td>
				</tr>
			</table>
			<!--  ������ Navigator �� -->

		</form>
	</div>
</body>
</html>
