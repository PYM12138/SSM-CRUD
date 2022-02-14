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
<!-- 员工增加模态框 -->
<div class="modal fade" id="emp_add_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">添加员工</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="modal_form">
                    <div class="form-group">
                        <label for="input_EmpName" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10" id="input_empName_div">
                            <input type="text" class="form-control" name="empName" id="input_EmpName"
                                   placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="input_email" class="col-sm-2 control-label">Email</label>
                        <div class="col-sm-10" id="input_email_div">
                            <input type="text" class="form-control" name="email" id="input_email"
                                   placeholder="xx@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <div class="checkbox">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="input_add_btn1" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="input_add_btn2" value="F"> 女
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="modal_add_select" class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="modal_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="modal_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

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
            <button class="btn btn-primary" id="btn_add">
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
        <%--分页具体数据--%>
        <div class="col-md-6" id="page_info">
        </div>
        <%--分页条--%>
        <div class="col-md-6" id="page_nav">
        </div>
    </div>

</div>


<script type="text/javascript">
    //最大页码标记
    var pageRecord;

    //1.在页面加载完成之后，发送ajax请求，拿到分页数据（这样就不需要通过转发的形式拿数据了）
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn=" + pn,
            type: "GET",
            success: function (result) {
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
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender === "M" ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.dept.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-info btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            var btnId = $("<td></td>").append(editBtn).append(" ").append(delBtn);

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
        var page_info = $("#page_info");
        page_info.empty();

        var page = result.extend.pageInfo;
        page_info.append($("<h4></h4>")
            .append("当前第" + page.pageNum + "页,总页数" + page.pages + "页,总记录" + page.total + "条"))
        pageRecord=page.total;
    }


    function build_page_nav(result) {
        //每次执行查询都必须先清空数据，防止数据在页面上堆叠
        $("#page_nav").empty();

        var ul = $("<ul></ul>").addClass("pagination");


        //首页和上一页
        var firstPage = $("<li></li>").append($("<a></a>")
            .attr("href", "#").append("首页"))
        var previousPage = $("<li></li>").append($("<a></a>").attr("href", "#")
            .append($("<span></span>").append("&laquo;")))


        ul.append(firstPage).append(previousPage);

        //设置点击跳转和在满足条件的时候禁用按钮
        if (result.extend.pageInfo.hasPreviousPage === false) {
            //禁用button按钮
            firstPage.addClass("disabled")
            previousPage.addClass("disabled")
        } else {
            firstPage.click(function () {
                to_page(1);
            });
            previousPage.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            })
        }


        //中间填充
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item))
            //高亮显示当前的页码数
            if (result.extend.pageInfo.pageNum === item) {
                numLi.addClass("active")
            }
            //设置点击跳转
            numLi.click(function () {
                to_page(item)
            })

            ul.append(numLi);
        })
        //尾页和下一页
        var lastPage = $("<li></li>").append($("<a></a>").attr("href", "#")
            .append("未页"))
        var nextPage = $("<li></li>").append($("<a></a>").attr("href", "#")
            .append($("<span></span>").append("&raquo;")))


        //设置点击跳转和在满足条件的时候禁用按钮
        if (result.extend.pageInfo.hasNextPage === false) {
            //禁用button按钮
            lastPage.addClass("disabled")
            nextPage.addClass("disabled")
        } else {
            lastPage.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
            nextPage.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            })
        }
        //<ul>标签
        ul.append(nextPage).append(lastPage)
        //<nav>标签
        var nav = $("<nav></nav>").append(ul)
        nav.appendTo("#page_nav");
    }


    //表单重置完全版
    function reset_form(ele) {
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-success has-error")
        $(ele).find(".help-block").text("")
    }

    //点击触发模态框(通过JS的方式叫手动)
    $("#btn_add").click(function () {
        /*//模态框弹出之前先进行表单重置
        $("#modal_form")[0].reset();
        //上次提交的绿边框会遗留下来，干脆在重置表单的时候一起移除了
        $("#input_email_div").removeClass("has-success has-error")
        $("#input_empName_div").removeClass("has-success has-error")*/

        reset_form("#modal_form");

        //打开模态框之前先查询部门数据
        departments();

        //打开模态框
        $("#emp_add_modal").modal({
            backdrop: "static"
        });
        //发现每次点击下拉菜单都是会叠加，所以得让它每次重新打开都要先清空之前的数据
        $("#modal_add_select").empty();
    })

    //获取部门信息然后填充到select标签中
    function departments() {
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success:function (result) {
                //{"code":100,"msg":"操作成功","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
                $.each(result.extend.depts,function (index, item) {
                    var option=$("<option></option>").append(item.deptName).attr("value",item.deptId);
                    option.appendTo("#modal_add_select");
                });
            }
        });

    }
    //模态框保存按钮
    $("#modal_save_btn").click(function (){
        //数据校验（这一步防止直接提交空表单）
        if (!validate_data_add_form()){//校验用户名
            validate_data_add_form1()
            return false;
        }

        if (!validate_data_add_form1()){//校验邮箱
            validate_data_add_form()
            return false;
        }
        //检查用户名是否重复，通过自定义属性的方式（根据用户名是否重复再次判断能否提交数据）
        if($(this).attr("ajax-va")==="error"){
            //给用户一个友好提示
            //validate_info_warn("#input_EmpName","error","用户名不可用")
            return false;
        }

        //保存数据
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data: $("#modal_form").serialize(),
            success:function (result) {
                if (result.code===100){
                    //关闭模态框
                    $("#emp_add_modal").modal('hide')
                    //跳转到最后一页(如果你的页面最大超过了当前的总页码(pages)，则默认最后一页，由分页插件提供的)
                    to_page(pageRecord)
                    //提示信息
                    alert(result.msg)
                }else{
                    //有哪个字段有错误就显示哪个
                    if (result.extend.errorField.email!==undefined){
                        validate_info_warn("#input_email","error",result.extend.errorField.email);
                    }
                    if (result.extend.errorField.empName!==undefined){
                        validate_info_warn("#input_EmpName","error",result.extend.errorField.empName)
                    }

                }

            }

        })
    })

    //数据校验用户名
    function validate_data_add_form() {
       var empName =$("#input_EmpName").val();
       //允许英文(大小写)和数字3-16位，允许中文2-5位
       var regxEmpName=/(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

       if (!regxEmpName.test(empName)){
           //校验失败直接返回一个false就会终止这个方法了
          // alert("英文和数字3-16位或中文2-5位")
           validate_info_warn("#input_EmpName","error","必须是英文和数字3-16位或中文2-5位");
            return false;
       }else{
           validate_info_warn("#input_EmpName","success","");
       }


       return true;
    }
    //数据校验邮箱
    function validate_data_add_form1() {
        var email=$("#input_email").val();
        var regxEmail=/^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
        if (!regxEmail.test(email)){
            // alert("邮箱格式不正确！")
            validate_info_warn("#input_email","error","邮箱格式不正确!");
            return false;
        }else{
            validate_info_warn("#input_email","success","邮箱格式正确");
        }

        return true;
    }
    //检查用户名是否重复（两次判断）
    $("#input_EmpName").change(function () {//当文本内容更改就开始检查
        var empName=$(this).val();

        if (!validate_data_add_form()){//首先判断用户名是否合理，合理才能下一步
            return false;
        }

        //1.发送ajax请求
        $.ajax({
            url:"${APP_PATH}/checkEmpName",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {//通过自定义的状态码来显示对应的信息
                if (result.code===100){
                    validate_info_warn("#input_EmpName","success","用户名可用")
                    //给保存按钮加自定义的属性，用于判断是否保存
                    $("#modal_save_btn").attr("ajax-va","success")
                }else{
                    validate_info_warn("#input_EmpName","error","用户名不可用")
                    $("#modal_save_btn").attr("ajax-va","error")
                }

            }
        })

    })

    //当邮箱填入之后就进行一个校验是否正确（没有这一步，邮箱校验只能在提交的时候才能知道是否合理）
    $("#input_email").change(function () {
        validate_data_add_form1();
    })
    //数据校验信息提取
    function validate_info_warn(ele,status,msg) {
        //数据校验前先清空class，防止样式堆叠
        $(ele).parent().removeClass("has-success has-error")
        $(ele).next("span").text("");

        if ("success"===status){
            $(ele).parent().addClass("has-success")
            $(ele).next("span").text(msg)

        }else if ("error"===status){
            $(ele).parent().addClass("has-error")
            $(ele).next("span").text(msg)
        }

    }



    
    

</script>


</body>
</html>
