<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="org.apache.tomcat.dbcp.dbcp2.PoolingConnection.StatementType"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.mysql.cj.xdevapi.PreparableStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	// 제목 입력 받은 값 변수에 담음
	String boardSeq = request.getParameter("boardSeq");
	String title = request.getParameter("title");
	// 내용
	String contents = request.getParameter("contents");
	
	// 검증
	boolean validate = true;
	// 에러 메세지
	String message = null;
	// null 또는 공백일 때
	if (title == null || title.isEmpty()) {
		message = "제목을 입력해주세요";
		validate = false;
	}
	// null 또는 공백일 때
	if (validate && contents == null || contents.isEmpty()) {
		message = "내용을 입력해주세요";
		validate = false;
	}
	boolean save = false;
	// 모든 필수 체크 로직이 성공했다면
	if (validate) {
		// DB에 접속을 하고 위에 내용을 저장하는 소스 구현
		Connection connection = null;
		PreparedStatement stmt = null;
		boolean update = false;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			// 데이터베이스 접촉을 위한 정보 set
			String jdbcUrl = "jdbc:mysql://localhost:3307/profile";
			// db 설치시 기입한 접속 정보set
			String user = "root";
			String password = "1234";
			// db 접속 커넥션을 획득
			connection = DriverManager.getConnection(jdbcUrl, user, password);
			
			
				// DB 커넥션 소스를 구현해야되요.
				
				// 편집화면에서 업데이트 요청인 경우..
				if (boardSeq != null && !boardSeq.isEmpty()) {
					String sql = "SELECT BOARD_SEQ, TITLE, CONTENTS, REG_DATE FROM T_BOARD " + 
							"WHERE BOARD_SEQ = " + boardSeq;
					Statement stmt2 = connection.createStatement();
					ResultSet rs = stmt2.executeQuery(sql);
					
					while (rs.next()) {
						update = true;
					}
				}
				
				
				
				String sql = null;
				
				//업데이트인 경우
				if (update){
					message = "게시물 편집이 완료되었습니다.";
					sql = "UPDATE T_BOARD SET TITLE = ?, CONTENTS = ? WHERE BOARD_SEQ = ?" ;
				} else {
					message = "게시물 등록이 완료되었습니다.";
					sql = "INSERT INTO T_BOARD (TITLE, CONTENTS, REG_DATE) " + 
							"VALUES (?, ?, NOW())";
					
				}
			
			
			// sql 쿼리를 실행하기 위한 statement 획득
			stmt = connection.prepareStatement(sql);
			stmt.setString(1, title);
			stmt.setString(2, contents);
			if (update){
				stmt.setString(3, boardSeq);
			}
			
			// database에 INSERT 쿼리를 실행 후 결과를 리턴 함
			int result = stmt.executeUpdate();
			if (result == 0) {
				message = "게시물 등록 중 오류가 발생 했습니다.";
			} else {
				save = true;
			}
			
			// DB 커넥션 소스 구현
		} catch (Exception e) {
			e.printStackTrace();
			message = "게시물 등록 중 DTATBASE 오류가 발생하였습니다.";
		}
	}
	
%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script>
		// 성공 실패에 대한 값을 set
		var save = <%=save%>;
		// 성공 또는 오류 메세지를 set
		var message = '<%=message%>';
		if (save) {
			alert(message);
			location.href = '/board/list.jsp';
		} else {
			alert(message);
			history.back(-1);
		}
	</script>
</body>
</html>