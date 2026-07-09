<%@ page language="java" contentType="application/json; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%
request.setCharacterEncoding("UTF-8");
String uploadPath = application.getRealPath("/upload/product");

File dir = new File(uploadPath);

if(!dir.exists()){
    dir.mkdirs();
}

MultipartRequest multi = new MultipartRequest(request, uploadPath, 10*1024*1024, "UTF-8", new DefaultFileRenamePolicy());

String type = multi.getParameter("imageType");
String fileName = multi.getFilesystemName("imageFile");

String url = "/upload/product/" + fileName;

out.print(
"{\"type\":\""
+ type
+ "\",\"url\":\""
+ url
+ "\"}"
);

%>
