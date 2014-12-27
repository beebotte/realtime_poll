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
        var optionsTotal = [0, 0, 0, 0];
        $(document).ready(function () {
            bbt = new BBT('502b09f9113252ba91d0fa24b2e69c1e', { ws_host: 'beebotte.com', auth_endpoint: '/api/authentications/bbt' });
            bbt.subscribe({ channel: 'Poll', resource: 'Q2', read: true, write: true }, function (message) {
                optionsTotal[message.data -1] += 1;
                updateResults();
            });
            GetResults();
        });

        function GetResults() {
            bbt.read({ owner: 'beebotte', channel: 'Poll', resource: 'Q2', limit: 10000 }, function (err, msg) {
                $(jQuery.parseJSON(JSON.stringify(msg))).each(function () {
                    optionsTotal[this.data - 1] += 1;
                });
                updateResults();
            });
        }

        function updateResults() {
            var total = 0;
            $(optionsTotal).each(function () {
                total += this;
            });
            if (total > 0) {
                $("#option1Perc").html(optionsTotal[0] + " votes");
                $("#option2Perc").html(optionsTotal[1] + " votes");
                $("#option3Perc").html(optionsTotal[2] + " votes");
                $("#option4Perc").html(optionsTotal[3] + " votes");

                $("#option1bar").html((optionsTotal[0] * 100 / total).toFixed(2) + "%");
                $("#option2bar").html((optionsTotal[1] * 100 / total).toFixed(2) + "%");
                $("#option3bar").html((optionsTotal[2] * 100 / total).toFixed(2) + "%");
                $("#option4bar").html((optionsTotal[3] * 100 / total).toFixed(2) + "%");

                $("#option1bar").width((optionsTotal[0] * 100 / total).toFixed(2) + "%");
                $("#option2bar").width((optionsTotal[1] * 100 / total).toFixed(2) + "%");
                $("#option3bar").width((optionsTotal[2] * 100 / total).toFixed(2) + "%");
                $("#option4bar").width((optionsTotal[3] * 100 / total).toFixed(2) + "%");
            }
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
      <div class="container">
<div class="page-header" >
   <h1>Beebotte Poll Demo <br />
       <small>with real-time results update</small>
      
   </h1>
</div>

        <div class="row">
            <div class="col-md-6">
                <div class="panel panel-primary">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <span class="glyphicon glyphicon-arrow-right"></span>  What is your favorite browser
                        </h3>
                    </div>
                    <ul class="list-group">
                        <li class="list-group-item">
                            <div class="radio">
                                <label>
                                    <input value="1" type="radio" name="optionsRadios"/>
                                    FireFox 
                                </label> (<span id="option1Perc" >0</span>)
                            </div>
                            <div class="progress">
                              <div id="option1bar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                                0%
                              </div>
                            </div>
                        </li>
                        <li class="list-group-item">
                            <div class="radio">
                                <label>
                                    <input value="2" type="radio" name="optionsRadios"/>
                                    Chrome
                                </label> (<span id="option2Perc" >0</span>)
                            </div>
                            <div class="progress">
                              <div id="option2bar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                                0%
                              </div>
                            </div>
                        </li>
                        <li class="list-group-item">
                            <div class="radio">
                                <label>
                                    <input value="3" type="radio" name="optionsRadios"/>
                                    Internet Explorer
                                </label> (<span id="option3Perc" >0</span>)
                            </div>
                            <div class="progress">
                              <div id="option3bar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                                0%
                              </div>
                            </div>
                        </li>
                        <li class="list-group-item">
                            <div class="radio">
                                <label>
                                    <input  value="4" type="radio" name="optionsRadios"/>
                                    Safari
                                </label> (<span id="option4Perc" >0</span>)
                            </div>
                            <div class="progress">
                              <div id="option4bar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width: 0%;">
                                0%
                              </div>
                            </div>
                        </li>
                    </ul>
                    <div class="panel-footer">
                        <button type="button" class="btn btn-primary" onclick="vote()">
                            Vote</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    </form>
</body>
</html>
