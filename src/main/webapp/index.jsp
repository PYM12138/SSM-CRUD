<%--
  Created by IntelliJ IDEA.
  User: HASEE
  Date: 2022/2/12
  Time: 11:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>员工列表</title>
    <%@ page isELIgnored="false" %>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <!-- web路径：
    不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
            http://localhost:3306/crud
     -->
    <script type="text/javascript"
            src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
    <link
            href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
            rel="stylesheet">
    <script
            src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>

<body>

<div class="container ">
    <%--标题行--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>

    <%--操作行--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">
                <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                新增
            </button>
            <button class="btn btn-danger">
                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                删除
            </button>
        </div>
    </div>

    <%--表格行--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>options</th>
                </tr>
                </thead>
                <tbody>
                </tbody>



            </table>
        </div>

    </div>
    <%--分页数据--%>
    <div class="row">
        <%--分页数据--%>
        <div class="col-md-6" id="page_info">
        </div>
        <%--分页条--%>
        <div class="col-md-6" id="page_nav">
        </div>
    </div>

</div>


<script type="text/javascript">
    //1.在页面加载完成之后，发送ajax请求，拿到分页数据（这样就不需要通过转发的形式拿数据了）
    $(function () {
        to_page(1);
    });
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                //1.解析并显示员工数据
                build_emps_table(result)
                //2.解析并显示分页信息
                build_page_info(result)
                //3.解析并显示分页条
                build_page_nav(result)


            }
        });
    }

    function build_emps_table(result) {
        //每次执行查询都必须先清空数据，防止数据在页面上堆叠
        $("#emps_table tbody").empty();
        var emps=result.extend.pageInfo.list;
        $.each(emps,function (index, item) {
            var empIdTd=$("<td></td>").append(item.empId);
            var empNameTd=$("<td></td>").append(item.empName);
            var genderTd=$("<td></td>").append(item.gender==="M"?"男":"女");
            var emailTd=$("<td></td>").append(item.email);
            var deptNameTd=$("<td></td>").append(item.dept.deptName);
            var editBtn=$("<button></button>").addClass("btn btn-info btn-sm")
                            .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                            .append("编辑");
            var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            var btnId=$("<td></td>").append(editBtn).append(" ").append(delBtn);

            //每次append都会返回一个原对象所以可以一直append
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnId)
                .appendTo("#emps_table tbody");
        });

    }

    function build_page_info(result) {
        //每次执行查询都必须先清空数据，防止数据在页面上堆叠
        var page_info= $("#page_info");
        page_info.empty();

        var page=result.extend.pageInfo;
        page_info.append($("<h4></h4>")
            .append("当前第"+page.pageNum+"页,总页数"+page.pages+"页,总记录"+page.total+"条"))
    }

    
    function build_page_nav(result) {
        //每次执行查询都必须先清空数据，防止数据在页面上堆叠
        $("#page_nav").empty();

        var ul=$("<ul></ul>").addClass("pagination");


        //首页和上一页
        var firstPage=$("<li></li>").append( $("<a></a>")
                        .attr("href","#").append("首页")  )
        var previousPage=$("<li></li>").append($("<a></a>").attr("href","#")
                        .append($("<span></span>").append("&laquo;")))


        ul.append(firstPage).append(previousPage);

        //设置点击跳转和在满足条件的时候禁用按钮
        if (result.extend.pageInfo.hasPreviousPage===false){
            //禁用button按钮
            firstPage.addClass("disabled")
            previousPage.addClass("disabled")
        }else {
            firstPage.click(function (){
                to_page(1);
            });
            previousPage.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            })
        }


        //中间填充
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi=$("<li></li>").append($("<a></a>").append(item))
            //高亮显示当前的页码数
            if (result.extend.pageInfo.pageNum===item){
                numLi.addClass("active")
            }
            //设置点击跳转
            numLi.click(function () {
                to_page(item)
            })

            ul.append(numLi);
        })
        //尾页和下一页
        var lastPage=$("<li></li>").append($("<a></a>").attr("href","#")
            .append("未页"))
        var nextPage=$("<li></li>").append($("<a></a>").attr("href","#")
            .append($("<span></span>").append("&raquo;")))


        //设置点击跳转和在满足条件的时候禁用按钮
        if (result.extend.pageInfo.hasNextPage===false){
            //禁用button按钮
            lastPage.addClass("disabled")
            nextPage.addClass("disabled")
        }else {
            lastPage.click(function (){
                to_page(result.extend.pageInfo.pages);
            });
            nextPage.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            })
        }
        //<ul>标签
        ul.append(nextPage).append(lastPage)
        //<nav>标签
        var nav=$("<nav></nav>").append(ul)
        nav.appendTo("#page_nav");
    }
</script>


</body>
</html>
