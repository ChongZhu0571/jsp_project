<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<html>
<head>
<link rel="stylesheet" href="pageUI.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>PRODUCT Register</title>
</head>
<body>
<%--Connect to the MySql database --%>
   <sql:setDataSource var="dbCon" driver="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/project" user="Chong" password="123456" />
<%--Validate if the user name exists --%>        
	<sql:query dataSource="${dbCon}" var='user_rs'>
        	select * from user where username=?
        	<sql:param value="${param.username}" />
    </sql:query>
<%--Validate if the product name exists --%> 
    <sql:query dataSource="${dbCon}" var='product_rs'>
        	select * from product where productname=?
        	<sql:param value="${param.productname}" />
    </sql:query>
<%--Validate if the product name matches its serial number --%> 
    <c:set var="serialno_match" value="false"/> 	
    <c:forEach var="product_row" items="${product_rs.rows}">
        <c:if test="${product_row.serialno == param.serialno}">
        	<c:set var="serialno_match" value="true"/> 	  	
	    </c:if>
    </c:forEach>
<%--JSP input page starting--%>     
        <div class="rg_layout">
        <div class="rg_left">
            <p>PRODUCT REGISTER</p>
        </div>
        <div class="rg_center">
                <form  method="post">
                    <table>
                        <tr>
                            <td class="td_left"><label for="username">* User Name:</label> </td>
                            <td class="td_right"><input type="text" name="username" id='username'> </td>
                            
                            <%--Show error information beside item when it is blank --%>
                            <c:choose>
	                            <c:when test="${param.registered &&empty param.username}">
	                            	<td><p style='color:red'>User name is required</p></td>
	                            </c:when>
	                            <c:when test="${param.registered &&user_rs.rowCount==0 }">
	                            	<td><p style='color:red'>Your user name does not exist,you can't register a product now.</p></td>
	                            </c:when>
                            </c:choose>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="productname">* Product Name:</label> </td>
                            <td class="td_right"><input type="text" name="productname" id='productname'> </td>
                            
                            <%--Show error information beside item when it is blank --%>
                            <c:choose>
                            	<c:when test="${param.registered &&empty param.productname}">
                            		<td><p style='color:red'>Product name is required</p></td>
                            	</c:when>
                            	<c:when test="${param.registered &&product_rs.rowCount==0 }">
                            		<td><p style='color:red'>Product name does not exist</p></td>
                            	</c:when>
                            </c:choose>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="serialno">* Serial number:</label> </td>
                            <td class="td_right"><input type="text" name="serialno" id='serialno'> </td>
                            
                            <%--Show error information beside item when it is blank --%>
                            <c:choose>
                            	<c:when test="${param.registered &&empty param.serialno}">
                            		<td><p style='color:red'>Serial number is required</p></td>
                            	</c:when>
                            	<c:when test="${param.registered && product_rs.rowCount!=0 }">
        	 	  					<c:if test="${!serialno_match}">
										  <td><p style='color:red'>Serial number dose not match the product</p></td>
                           			</c:if>
        	 					</c:when>
                            </c:choose>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="pdate">* Purchase Date:</label> </td>
                            <td class="td_right"><input type="date" name="pdate" id='pdate'> </td>
                            
                            <%--Show error information beside item when it is blank --%>
                            <c:if test="${param.registered &&empty param.pdate}">
                            	<td><p style='color:red'>Date is required</p></td>
                            </c:if>
                        </tr>
                        
                    </table>
                    <div class='rg_bottom'>
                    	<button type="submit" value="true" name="registered" id="btn_sub">Register</button>
                    	Not a member?<a href="register.jsp"> Register an account Now</a>
                    </div>
                </form>

 
<%--Insert data into table when validation completed --%>  
    <c:if test="${not empty param.username
            	                   && not empty param.productname
                                   && not empty param.serialno
                                   && not empty param.pdate
                                   &&  user_rs.rowCount!=0
                                   &&  product_rs.rowCount!=0
                                   &&  serialno_match
                                   }">
      	<c:catch var='errorHandling'>
      		<sql:update dataSource="${dbCon}" var="insertProduct">
            INSERT INTO product_registered
                            VALUES (?, ?, ?, ?);
            <sql:param value="${param.username}" />
            <sql:param value="${param.productname}" />
            <sql:param value="${param.serialno}" />
            <sql:param value="${param.pdate}" />
        	</sql:update>
        	<p style='color:red'><c:out value='product register successfully!'/>
      	</c:catch>
      	
<%--Show message if it has an exception in the result of insertion --%>
      	<c:if test="${not empty errorHandling }">
      		<p style='color:red'><c:out value='${errorHandling.message}'/></p>
      	</c:if>
        
    </c:if>
        </div>
    </div>
    <br/><br/>
    
   </body>
</html>