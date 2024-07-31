<% @Page Language="C#"%>

<script runat="server">
    private void calc(object sender, EventArgs e){
        int numb1 = Int32.Parse(num1.Value);
        int numb2 = Int32.Parse(num2.Value);
        String anss = Convert.ToString(numb1 + numb2);
        Response.Write("<font color=red>" + anss + "</font>");
        answ.Value = Convert.ToString(numb1 + numb2);
    }
</script>
<html>
    <body>
        <h3 Simple Calculator </h3>
            <form runat="server">
            <input runat="server" id="num1" type="text" /><br>
            <input runat="server" id="num2" type="text" /><br>
            <input runat="server" id="answ" type="text" />
            <input runat="server" id="button1" type="submit" value="add" OnServerClick="calc" />
            </form>
    </body>
</html>