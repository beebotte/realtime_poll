using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using Beebotte.API.Server.Net;
using Poll_Demo.Models;

namespace Poll_Demo.Controllers
{
    public class AuthenticationsController : ApiController
    {
        public IHttpActionResult GetAuthentication(string id)
        {
            NameValueCollection requestParams = HttpUtility.ParseQueryString(Request.RequestUri.Query);
            var authentication = new Authentication();
            string accessKey = "502b09f9113252ba91d0fa24b2e69c1e";
            string secureKey = "88303a6fdc866caeea2fe3bf4746611d16dce93196973d77e2037887f8fc6197";
            string signature = String.Empty;
            var channel = requestParams["channel"];
            var resource = requestParams["resource"];
            var read = requestParams["read"];
            var write = requestParams["write"];
            var sid = requestParams["sid"];
            string userid = requestParams["userid"];
            var toSign = String.IsNullOrEmpty(userid) ? String.Format("{0}:{1}.{2}:ttl={3}:read={4}:write={5}", sid, channel, resource, "0", read, write) :
            String.Format("{0}:{1}.{2}:ttl={3}:read={4}:write={5}:userid={6}",
            sid, channel, resource, "0", read,
            write, userid);
            signature = String.Format("{0}:{1}", accessKey, Utilities.GenerateHMACHash(toSign, secureKey));
            authentication.auth = signature;
            return Ok(authentication);
        }
    }
}
