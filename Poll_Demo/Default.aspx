<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Poll_Demo.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Beebotte Poll Demo</title>
       <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    
    <script src="Scripts/bootstrap.js"></script>
      <script src="http://cdn.socket.io/socket.io-1.1.0.js"></script>
  <script src="Scripts//bbt.js"></script>
    <script>
        var bbt;
        $(document).ready(function () {
            bbt = new BBT('502b09f9113252ba91d0fa24b2e69c1e', { ws_host: 'beebotte.com', auth_endpoint: '/api/authentications/bbt' });
            bbt.subscribe({ channel: 'Poll', resource: 'Q2', read: true, write: true }, function (message) {
                GetResults();
            });
            GetResults();
        });

        function GetResults()
        {
            bbt.read({ owner: 'beebotte', channel: 'Poll', resource: 'Q2', limit: 10000 }, function (err, msg) {
                var option1Total = 0;
                var option2Total = 0;
                var option3Total = 0;
                var option4Total = 0;
                var total = 0;

                $(jQuery.parseJSON(JSON.stringify(msg))).each(function () {
                    total++;
                    if (this.data == 1) {
                        option1Total++;
                    }
                    else if (this.data == 2) {
                        option2Total++
                    }
                    else if (this.data == 3) {
                        option3Total++
                    }
                    else if (this.data == 4) {
                        option4Total++
                    }
                });
                if (total > 0) {
                    $("#option1Perc").html((option1Total * 100 / total).toFixed(2));
                    $("#option2Perc").html((option2Total * 100 / total).toFixed(2));
                    $("#option3Perc").html((option3Total * 100 / total).toFixed(2));
                    $("#option4Perc").html((option4Total * 100 / total).toFixed(2));
                }
            });
        }

        function vote()
        {
            var selected = $("input:radio[name='optionsRadios']:checked").val();
            if (selected !== undefined) {
                bbt.write({ channel: 'Poll', resource: 'Q2' }, parseInt(selected));
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
<div class="page-header" >
   <h1>Beebotte Poll Demo
       <small>with real-time results update</small>
      
   </h1>
</div>

         <div class="container">
        <div class="row">
            <div class="col-md-3">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <span class="glyphicon glyphicon-arrow-right"></span>What is your favorite browser
                        </h3>
                    </div>
                    <div class="panel-body">
                        <ul class="list-group">
                            <li class="list-group-item">
                                <div class="radio">
                                    <label>
                                        <input value="1" type="radio" name="optionsRadios">
                                        FireFox 
                                    </label> (<span id="option1Perc" >0</span>%)
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="radio">
                                    <label>
                                        <input value="2" type="radio" name="optionsRadios">
                                        Chrome
                                    </label> (<span id="option2Perc" >0</span>%)
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="radio">
                                    <label>
                                        <input value="3" type="radio" name="optionsRadios">
                                        Internet Explorer
                                    </label> (<span id="option3Perc" >0</span>%)
                                </div>
                            </li>
                            <li class="list-group-item">
                                <div class="radio">
                                    <label>
                                        <input  value="4" type="radio" name="optionsRadios">
                                        Safari
                                    </label> (<span id="option4Perc" >0</span>%)
                                </div>
                            </li>
                        </ul>
                    </div>
                    <div class="panel-footer">
                        <button type="button" class="btn btn-primary btn-sm" onclick="vote()">
                            Vote</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>
</body>
</html>
