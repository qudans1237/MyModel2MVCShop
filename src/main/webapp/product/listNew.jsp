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
	
	//fncGetProductList(currentPage) �Դϴ�~~~
	function fncGetList(currentPage) {

		$("#currentPage").val(currentPage)

		$("form").attr("method", "POST").attr("action","/product/listProduct?menu=${param.menu}").submit();
	}

	$(function() {
		
		$(".ct_list_pop td:nth-child(1)").on("click",function() {
			self.location = "/product/getProduct?prodNo="
					+ $(this).children("input").val()
					+ "&menu=${param.menu}";
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
							"</h3>";

							//alert(displayValue);
							$("h3").remove();
							$("#" + prodNo + "").html(displayValue);
						}
					});
				});

		$(".ct_list_pop td:nth-child(3)").css("color", "#0174DF");
		$(".ct_list_pop td:nth-child(1)").css("color", "#00BFFF");

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
									what's New
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
					<td colspan="11">��ü ${resultPage.totalCount } �Ǽ�, ����
						${resultPage.currentPage } ������</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="100" >No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="350">��ǰ��<br> <h7>(��ǰ��click:������)</h7>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">����</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="250">��ǰ������</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="100">�������</td>
					<td class="ct_line02"></td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>


				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list }">
					<c:set var="i" value="${i+1 }" />
					<tr class="ct_list_pop">
						<td align="center" height="100"><input type="hidden" name="prodNo"
							value="${product.prodNo }" />${i }</td>
						<td></td>
						<td align="left"><input type="hidden" name="prodNo"
							value="${product.prodNo }" /> <img src="/images/uploadFiles/${product.fileName}" width="100" height="100"/>${product.prodName }</td>
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
