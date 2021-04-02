<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<html>
<head>
<link rel="stylesheet" href="pageUI.css">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Register</title>
</head>
<body>
     <div class="rg_layout">
        <div class="rg_left">
            <p>USER REGISTER</p>
        </div>
        <div class="rg_center">
                <form  method="post">
                    <table>
                        <tr>
                            <td class="td_left"><label for="username">* User Name:</label> </td>
                            <td class="td_right"><input type="text" name="username" id='username'> </td>
 							
 							<%--Show error information beside item when it is blank --%>
                            <c:if test="${param.registered &&empty param.username}">
                            	<td><p style='color:red'>User name is required</p></td>
                            </c:if>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="password">* Password:</label> </td>
                            <td class="td_right"><input type="password" name="password" id='password'> </td>
                            
                            <%--Show error information beside item when it is blank --%>
                            <c:if test="${param.registered &&empty param.password}">
                            	<td><p style='color:red'>Password is required</p></td>
                            </c:if>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="phone">* Cell Phone:</label> </td>
                            <td class="td_right"><input type="number" name="phone" id='phone'> </td>
                            <c:if test="${param.registered &&empty param.phone}">
                            	<td><p style='color:red'>Cell Phone is required</p></td>
                            </c:if>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="email">* Email:</label> </td>
                            <td class="td_right"><input type="email" name="email" id='email'> </td>
                            <c:if test="${param.registered &&empty param.email}">
                            	<td><p style='color:red'>Email is required</p></td>
                            </c:if>
                        </tr>
                        <tr>
                            <td class="td_left"><label for="address">* Address:</label> </td>
                            <td class="td_right"><input type="text" name="address" id='address'> </td>
                            <c:if test="${param.registered &&empty param.address}">
                            	<td><p style='color:red'>Address is required</p></td>
                            </c:if>
                        </tr>
                        
                    </table>
                    <div class='rg_bottom'>
                    	<button type="submit" value="true" name="registered" id="btn_sub">Register</button>
                    	Already a member?<a href="productRegister.jsp"> Register a product Now</a>
                    </div>
                </form>
                <br/><br/> 
                
<%--Connect to MySql database --%>  
    <sql:setDataSource var="dbCon" driver="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/project" user="Chong" password="123456" />
        
<%--Insert data into table when validation completed --%>    
    <c:if test="${not empty param.username
                                   && not empty param.password
                                   && not empty param.phone
                                   && not empty param.email
                                   && not empty param.address
                                   }">  
		<c:catch var='errorHandling'>
        <sql:update dataSource="${dbCon}" var="insertUser">
            INSERT INTO user
                 VALUES (?, ?, ?, ? ,?);
            <sql:param value="${param.username}" />
            <sql:param value="${param.password}" />
            <sql:param value="${param.phone}" />
            <sql:param value="${param.email}" />
            <sql:param value="${param.address}" />
        </sql:update>
        <p style='color:red'><c:out value='account register successfully!'/>
		</c:catch>    
    </c:if>
    
<%--Show message if it has an exception in the result of insertion --%>
    <c:if test="${not empty errorHandling }">
      	<p style='color:red'><c:out value='${errorHandling.message}'/></p>
     </c:if>
     
    <sql:query dataSource="${dbCon}" var="selectQuery">
        SELECT * from user;
    </sql:query>
    <table border="1">
    	<tr>
                <th>Username</th>
                <th>Password</th>
                <th>Phone Number</th>
                <th>Email</th>
                <th>Address</th>
            </tr>
        <c:forEach var="row" items="${selectQuery.rows}">
            <tr>
                <td><c:out value="${row.username}" /></td>
                <td><c:out value="${row.password}" /></td>
                <td><c:out value="${row.phone}" /></td>
                <td><c:out value="${row.email}" /></td>
                <td><c:out value="${row.address}" /></td>
            </tr>
        </c:forEach>
    </table>  
      </div>
    </div>
    
   </body>
</html>