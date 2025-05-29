Class FHIRSeek.Web.Home Extends FHIRSeek.Web.Base
{

Parameter Screen = "FHIR Seek";

Parameter FHIRServerCls = "FHIRSeek.Web.FHIRServer.cls";

ClassMethod OnPage() As %Status
{
	Do ##super()
	Do ..DisplayFHIRServers()
	Quit $$$OK
}

ClassMethod DisplayFHIRServers()
{
	Write "<h2>FHIR Servers</h2><div class=""server-list"">"
	Set fhirservers = ##class(FHIRSeek.Web.Utils).GetFHIRServers().%GetIterator()
	While fhirservers.%GetNext(,.val) {
		 Write "<div class=""server-item"">"_
      	"<div class=""server-details"">"_
        "<p class=""server-title"">"_val.name_"</p>"_
        "<p class=""server-meta"">"_val.url_"</p></div>"
        s ec = ..EncryptEncode(val.id)
        If val.active {
	        Write "<a class=""server-link"" href="_..#FHIRServerCls_"?id="_..EncryptEncode(val.id)_" target=""_blank"">"_..svgs("connectorSvg")_" </a>"
	        If ('val.IsISCFHIRServer) {
		        W " <button style=""all: unset; cursor: pointer;"" onclick=""editServer('"_..EncryptEncode(val.id)_"')""> "_..svgs("editSvg")_" </button>"
		        W " <button style=""all: unset; cursor: pointer;"" onclick=""deleteServer('"_..EncryptEncode(val.id)_"')""> "_..svgs("deleteSvg")_" </button>"
	        }
        }
        Else {
	        Write "<a class=""server-link"" href=""#""> </a>"
        }
      	Write "</div>"
	}
	Write "</div>"
	Write "<div style=""text-align: center; margin-top: 20px;""><button id=""newServerBtn"">+ New Server</button></div>"
	&HTML<

	<!-- Modal -->
<div id="serverModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center;">
  <div style="background:white; padding:20px; border-radius:8px; max-width:400px; width:100%; position:relative;">
    <h3>Add New External FHIR Server</h3>
    <form id="serverForm">
    	<input type="hidden" name="fhirserver" id="fhirserver">
      <label>Server Name</label><br>
      <input type="text" name="serverName" placeholder="InterSystems" required style="width:100%; margin-bottom:10px;"><br>
      <!-- host -->
      <label>Host</label><br>
      <input type="text" name="host" placeholder="hapi.fhir.org" required style="width:100%; margin-bottom:10px;"><br>
      <!-- port -->
      <label>Port</label><br>
      <input type="text" name="port" placeholder="52773" style="width:100%; margin-bottom:10px;"><br>
      <!-- fhir url -->
      <label>URL</label><br>
      <input type="text" name="url" placeholder="/BaseR4" required style="width:100%; margin-bottom:10px;"><br>

      <label>Version</label><br>
      <input type="text" name="version" placeholder="R4" style="width:100%; margin-bottom:10px;"><br>
      <label>Description</label><br>
      <input type="text" name="description" style="width:100%; margin-bottom:10px;" maxlength="500"><br>

		<!-- Auth types -->
		<div class="custom-select">
		<label>Authorization</label><br>
		<select name="authType"  style="width:100%; margin-bottom:10px;" onchange="showcreds()">
		  <option value=""></option>
		  <option value="basic">Basic</option>
		</select>
		</div>

		<div id="creds" style="display:none;">
		  <label>Username</label><br>
		  <input type="text" name="username" placeholder="_SYSTEM" style="width:100%; margin-bottom:10px;"><br>
		  <label>Password</label><br>
		  <input type="password" name="password" style="width:100%; margin-bottom:10px;"><br>
		</div>

      <button type="button" onclick="testConnection()">Test Connection</button>
      <button type="submit" class="submitServerBtn" id="submitServerBtn">Add Server</button>
      <button type="button" onclick="closeModal()">Cancel</button>
    </form>
  </div>
</div>
<script language="javascript">
  const modal = document.getElementById("serverModal");
  const newServerBtn = document.getElementById("newServerBtn");
  const serverForm = document.getElementById("serverForm");

	function deleteServer(fhirserver) {
		if (confirm("Are you sure you want to delete this server?")) {
		  #server(..DeleteFHIRServer(fhirserver))#
		  alert('deleted');
		  location.reload();
		  return;
		} else {
		  alert("Delete canceled.");
		}
	}
	function showcreds() {
		const select = document.querySelector('select[name="authType"]');
		const credsDiv = document.getElementById("creds");
		if (select.value === "basic") {
		    credsDiv.style.display = "block";
		 }
		 else {
		    credsDiv.style.display = "none";
		 }
	}
 // add new / edit server model
  newServerBtn.onclick = () => {
	  modal.style.display = "flex"
	  document.getElementById("submitServerBtn").textContent = "Add Server";
  };

  function closeModal() {
    modal.style.display = "none";
    serverForm.reset();
  }

  function testConnection() {
    const url = serverForm.url.value;
    if (!url) {
      alert("Please enter a URL first.");
      return;
    }

    fetch(url + "/metadata", {
      method: "GET",
      headers: { "Accept": "application/fhir+json" }
    })
    .then(response => {
      if (response.ok) {
        alert("Connection successful!");
      } else {
        alert("Connection failed: " + response.status);
      }
    })
    .catch(error => {
      alert("Connection error: " + error.message);
    });
  }

  serverForm.onsubmit = (e) => {
    e.preventDefault();
    const data = new FormData(serverForm);
    const serverName = data.get("serverName");
    const description = data.get("description");
    const host = data.get("host");
    const port = data.get("port");
    const url = data.get("url");
    const fhirserver = data.get("fhirserver");

    const version = data.get("version");
    let newServerInfo = {
	     FHIRServerName: serverName,
	     Description: description,
	     Host: host,
	     Port: port,
	     FHIRUrl: url,
	     Version: version,
	     Active: true

    };
    const authType = data.get("authType")|| '';

    if (authType=='basic') {
    	const authusr = data.get("username")|| '';
    	const authpwd = data.get("password")|| '';
    	newServerInfo.AuthType = {"AuthType":'basic', "PasswordHash": btoa(`${authusr}:${authpwd}`)}
    }
    const serverList = document.querySelector(".server-list");
    const newItem = document.createElement("div");
    newItem.className = "server-item";
    if (serverForm.getAttribute("data-mode")=="edit") {
	    #server(..HandleFHIRServer(JSON.stringify(newServerInfo),fhirserver))#
    }
    else {
    	#server(..HandleFHIRServer(JSON.stringify(newServerInfo)))#
    }
    newItem.innerHTML = `
      <div class="server-details">
        <p class="server-title">${serverName}</p>
        <p class="server-meta">${url}</p>
      </div>
      <a class="server-link" href="MyFHIR.Web.ExtFHIRServer.cls?url=${encodeURIComponent(url)}" target="_blank">Visit</a>
    `;
    serverList.appendChild(newItem);
    closeModal();
    location.reload();
  };

  /// Edit previous fhir server info
  function editServer(fhirserverid) {
	  modal.style.display = "flex";
	  jstr = #server(..EditFHIRServer(fhirserverid))#
	  serverData = JSON.parse(jstr);
	  serverForm.fhirserver.value = serverData.fhirserver|| "";
	  serverForm.serverName.value = serverData.serverName || "";
	  serverForm.description.value = serverData.description || "";
	  serverForm.host.value = serverData.host || "";
	  serverForm.port.value = serverData.port || "";
	  serverForm.url.value = serverData.url || "";
	  serverForm.version.value = serverData.version || "";
	  //
	  if (serverData.AuthType && serverData.AuthType.AuthType === "basic") {
		  try {
		    const decoded = atob(serverData.AuthType.PasswordHash); // Decode base64
		    [serverData.username, serverData.password] = decoded.split(":"); // Split into parts
		    serverForm.authType.value = "basic";
		    showcreds(); // Show the credential fields
		    serverForm.username.value = serverData.username || "";
		    serverForm.password.value = serverData.password || "";
		  } catch (error) {
		    console.error("Failed to decode Basic Auth credentials:", error);
		  }
	  } else {
	    serverForm.authType.value = "";
	    showcreds();
	  }
		document.getElementById("submitServerBtn").textContent = "Update Server";
	  serverForm.setAttribute("data-mode", "edit");
}

</script>

	>
}

// ClassMethod HandleFHIRServer(serverList As %String, serverName As %String, url As %String, description As %String, Host, Port) [ Language = objectscript ]

ClassMethod HandleFHIRServer(FHIRServerJSON As %String, FHIRServerId As %String = "")
{
	If FHIRServerId'="" {
		Set sc = ##Class(FHIRSeek.FHIR.Utils).UpdateFHIRServer({}.%FromJSON(FHIRServerJSON),..DecodeDecrypt(FHIRServerId))
	}
	Else{
		Set sc = ##Class(FHIRSeek.FHIR.Utils).AddExternalFHIRServer({}.%FromJSON(FHIRServerJSON))
	}
	If $$$ISERR(sc) {
			Set msg = "'Failed to add the server'"
		}
		Else {
			Set msg= "'Saved'"
		}
	&JS<alert(#(msg)#)>
	Return $$$OK
}

ClassMethod DeleteFHIRServer(FHIRServerId As %String = "")
{
	If FHIRServerId'="" {
		Return ##Class(FHIRSeek.FHIR.Utils).DeleteFHIRServer(..DecodeDecrypt(FHIRServerId))
	}
	Return 1
}

ClassMethod EditFHIRServer(FHIRServerId As %String)
{
	Set fhirId = ..DecodeDecrypt(FHIRServerId)
	Set json = ##class(FHIRSeek.FHIR.Utils).GetFHIRServerInfo(fhirId)
	If $IsObject(json) {
		Set response = {
		"fhirserver":(FHIRServerId),
		"serverName":(json.FHIRServerName),
		"description": (json.Description),
		"host":(json.Host),
		"port":(json.Port),
		"url":(json.FHIRUrl),
		"version":(json.Version)
		}
		If json.%IsDefined("AuthType") {
			If json.AuthType.AuthType="basic" {
				Do response.%Set("AuthType",{"AuthType":"basic","PasswordHash":(json.AuthType.PasswordHash)})
			}
		}
	}
	Return response.%ToJSON()
}

ClassMethod OnPreHTTP() As %Boolean
{
	q 1
}

XData css
{
<data><![CDATA[body {font-family: ui-monospace,Roboto, sans-serif;padding: 20px;background-color: #f5f5f5;}.server-list {max-width: 900px;margin: auto;display: flex;flex-direction: column;gap: 10px;}.server-item {box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); background: #fff;border: 1px solid #ccc;border-left: 5px solid #007acc;padding: 10px 15px;font-size: 14px;line-height: 1.4;display: flex;justify-content: space-between;align-items: center;height: 60px; transition: 0.3s; /* Small height */overflow: hidden;} .server-item:hover {
  box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);}.server-details {flex-grow: 1;} input:focus::placeholder {color: transparent;}  input[type=text],input[type="password"] { width: 100%; padding: 4px 4px; margin: 8px 0; box-sizing: border-box; border: none; border-bottom: 2px solid gray;} button {background-color: #2B3589;color: #fff;padding: 5px;font-family: 'Roboto', sans-serif;border-radius: 6px;} .server-title {font-weight: bold;color: #333;margin: 0;}.server-meta {font-size: 12px;color: #666;}.server-link {color: #007acc;font-size: 13px;text-decoration: none;white-space: nowrap;}.server-link:hover {text-decoration: underline;} .custom-select { min-width: 100px;} .custom-select select { appearance: none; width: 100%;  padding: 5px; background-color: #fff; border: 1px solid #caced1; border-radius: 0.25rem; color: #000; cursor: pointer;}]]></data>
}

}
