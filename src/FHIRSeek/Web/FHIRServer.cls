Class FHIRSeek.Web.FHIRServer Extends FHIRSeek.Web.Base
{

Parameter Screen;

// Parameter CSPURL = "MyFHIR.Web.FHIRServer.cls";

ClassMethod OnPage() As %Status
{
	Do ##super()
	Do ..LoadResources()
	Quit $$$OK
}

ClassMethod LoadResources()
{
	set fhirServerId  = ..DecodeDecrypt($Get(%request.Data("id",1)))
	Write "<div id=""sidebar"">"
	Write "<h3>Recent</h3>"
    Write "<div id=""recentResources""></div>"
	Write "<h3>All Resources</h3>"
	Write " <input type=""text"" id=""searchBox"" placeholder=""Search resources..."" onkeyup=""filterResources()"">"
	Write "<div id=""allResources"">"
	Set response = ##class(FHIRSeek.Web.Utils).SendGetRequest(fhirServerId,"/metadata")
	Set fhirServerUrl = ##class(FHIRSeek.FHIR.Utils).GetFHIRUrl(fhirServerId)
	s ^x1c = fhirServerUrl_","_fhirServerId
	Do ..SetFHIRServerIntoSession(fhirServerId)
	If $IsObject(response) {
		Set iter = response.rest.%GetIterator()
		Do iter.%GetNext(,.val)
		Set iter= val.resource.%GetIterator()
		While iter.%GetNext(,.resource) {
			Write "<div class=""resource-item"" onclick=""selectResource(this)""><span class=""resource-name"">"_resource.type_"</span>"
			;resource count
			If resource.%IsDefined("extension") {
				Set extensionIter = resource.extension.%GetIterator()
				While extensionIter.%GetNext(,.extensionVal) {
					If extensionVal.url["#resourceCount" W "<span class=""resource-count"">"_extensionVal."valueDecimal"_"</span>"
				}
			}
			Write "</div>"
			Set searchParam=[], headers=[],headers1=[]
			If $IsObject(resource.searchParam) {
				Set searchParamIter = resource.searchParam.%GetIterator()
				While searchParamIter.%GetNext(,.searchitem) {
					Set dataElement = searchitem.name
					Do searchParam.%Push(dataElement)
					If ..IsPrimitiveDT(searchitem.type)&&($E(dataElement)'="_") {
						Do headers.%Push(dataElement)
					}
					If $E(dataElement)="_" {
						Do headers1.%Push(dataElement)
					}
				}
			}
			If searchParam'="" {
				Set ^CacheTemp(%session.SessionId,resource.type,"searchParam")=searchParam.%ToJSON()
				Set ^CacheTemp(%session.SessionId,resource.type,"headers")= $S(headers.%Size():headers.%ToJSON(),1:headers1.%ToJSON())
			}
		}
	}
	Write " </div>"
	Write " </div>"
	;
	;
	/// Resources details will load here
	Write "<div id=""main"">"
    //Write " <h1>Welcome</h1>"
   	Write "<div id='searchParams' style='display:none;'>Search parameters: <Select > </Select></div>"
    //Write "<p>Select a resource from the left panel to view more.</p>"
    write "<table id='records'></table>"
   	Write "</div>"
  &HTML<
  	<script language="javascript">

  	const recentContainer = document.getElementById("recentResources");
    const allResources = Array.from(document.querySelectorAll("#allResources .resource-item"));
    const searchBox = document.getElementById("searchBox");
    const MAX_RECENTS = 5;
    let recent = [];

    function filterResources() {
        const query = searchBox.value.toLowerCase();
        allResources.forEach(item => {
            const name = item.querySelector(".resource-name").textContent.toLowerCase();
            item.style.display = name.includes(query) ? "" : "none";
        });
    }

	// select each resource from the sidebar to render the resource as data table
    function selectResource(elem) {
        const resourceName = elem.querySelector(".resource-name").textContent;
        //const resourceCount = elem.querySelector(".resource-count").textContent;
        const fhirServerurl = '#(%session.Data("fullUrl"))#';
        const fhirid=`'#($Get(%request.Data("id",1)))#'`;
        const fullUrl = `${fhirServerurl}/${resourceName}`;
     	const headers = new Headers();
     	auth = #server(..ValidateAuth(fhirid))#;
     	if (auth != null) {
	     	headers.append("Authorization", auth);
     	}
     	else {
     	}
		headers.append("Content-Type", "application/fhir+json"); // optional depending on the API
     	//console.log("Request Headers:", Array.from(headers.entries())); // Log headers
     	fetch(fullUrl, {
			  method: 'GET',
			  headers: headers
			})
			.then(response => response.json())
			.then(bundle => {
			    //console.log("Response:", bundle);
			    renderPatientTableWithPagination(bundle,20,resourceName);
			})
		    .catch(error => console.error("Error:", error));

        //document.getElementById("main").innerHTML = `<h1>${resourceName}</h1><p>Count: ${resourceCount}</p>`;

        // Avoid duplicates in recent

     	recent = recent.filter(r => r.name !== resourceName);

        // Add to top
        recent.unshift({ name: resourceName});

        // Limit recents
        if (recent.length > MAX_RECENTS) recent.pop();

        renderRecents();


    }

    function renderRecents() {
        recentContainer.innerHTML = '';
        //alert(r);
        recent.forEach(r => {
            const div = document.createElement('div');
            div.className = 'resource-item';
            div.onclick = () => selectResource(div);
            div.innerHTML = `<span class="resource-name">${r.name}</span>`;
            recentContainer.appendChild(div);
        });
    }
    /// start ////
    function renderPatientTableWithPagination(bundle, rowsPerPage = 5,resourceName) {
  		const container = document.getElementById('records');
  		container.innerHTML = '';

		if (!bundle.entry || bundle.entry.length === 0) {
		    container.textContent = "No data found.";
		    return;
		  }

	  const eResource = bundle.entry.map(e => e.resource);
	  let currentPage = 1;
	  const totalPages = Math.ceil(eResource.length / rowsPerPage);

  function renderPage(page) {
    container.innerHTML = ''; // clear
    const table = document.createElement('table');
    table.style.borderCollapse = 'collapse';
    table.style.width = '100%';

    // Headers
    const headers = JSON.parse(#server(..GetResourceDatas(resourceName,"headers"))#); // ['ID', 'Name', 'Gender', 'Birth Date'];
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    headers.forEach(text => {
      const th = document.createElement('th');
      th.textContent = text;
      th.style.border = '1px solid #ccc';
      th.style.padding = '8px';
      th.style.backgroundColor = '#eee';

      headerRow.appendChild(th);
    });
    thead.appendChild(headerRow);
    table.appendChild(thead);

    // Body
    const tbody = document.createElement('tbody');
    const start = (page - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    const pageResource = eResource.slice(start, end);

    pageResource.forEach(resource => {
      const row = document.createElement('tr');
      headers.forEach(val => {
        const td = document.createElement('td');
        td.textContent = extractValue(resource[val]);
        td.style.border = '1px solid #ccc';
        td.style.padding = '8px';
        row.appendChild(td);
      });

      tbody.appendChild(row);
    });

    table.appendChild(tbody);
    container.appendChild(table);

    // Pagination Controls
    const pagination = document.createElement('div');
    pagination.style.marginTop = '10px';

    const prevBtn = document.createElement('button');
    prevBtn.textContent = '◀ Previous';
    prevBtn.disabled = page === 1;
    prevBtn.onclick = () => {
      currentPage--;
      renderPage(currentPage);
    };

    const nextBtn = document.createElement('button');
    nextBtn.textContent = 'Next ▶';
    nextBtn.disabled = page === totalPages;
    nextBtn.onclick = () => {
      currentPage++;
      renderPage(currentPage);
    };

    const pageLabel = document.createElement('span');
    pageLabel.textContent = ` Page ${page} of ${totalPages} `;
    pageLabel.style.margin = '0 10px';

    pagination.appendChild(prevBtn);
    pagination.appendChild(pageLabel);
    pagination.appendChild(nextBtn);
    container.appendChild(pagination);
  }

  renderPage(currentPage);
}


    /// end///

    function extractValue(value) {
	  if (value == null) return '';

	  if (typeof value === 'string' || typeof value === 'number' || typeof value === 'boolean') {
	    return value.toString();
	  }

	  if (Array.isArray(value)) {
	    return value.map(extractValue).join(', ');
	  }

	  if (typeof value === 'object') {
	    // Flatten object to key=value pairs
	    return Object.entries(value)
	      .map(([k, v]) => `${k}: ${extractValue(v)}`)
	      .join(', ');
	  }

  return '';
}





    function renderPatientTable(bundle) {
  // Find the container where the table will go
  const container = document.getElementById('main');
  container.innerHTML = ''; // Clear previous content

  if (!bundle.entry || bundle.entry.length === 0) {
    container.textContent = "No patient data found.";
    return;
  }

  // Create table and header row
  const table = document.createElement('table');
  table.style.borderCollapse = 'collapse';
  table.style.width = '100%';

  const headers = ['ID', 'Name', 'Gender', 'Birth Date'];
  const thead = document.createElement('thead');
  const headerRow = document.createElement('tr');
  headers.forEach(text => {
    const th = document.createElement('th');
    th.textContent = text;
    th.style.border = '1px solid #ccc';
    th.style.padding = '8px';
    th.style.backgroundColor = '#eee';
    headerRow.appendChild(th);
  });
  thead.appendChild(headerRow);
  table.appendChild(thead);

  // Create tbody and rows for each patient
  const tbody = document.createElement('tbody');

  bundle.entry.forEach(entry => {
    const patient = entry.resource;
    const row = document.createElement('tr');

    // ID
    const idCell = document.createElement('td');
    idCell.textContent = patient.id || '';
    idCell.style.border = '1px solid #ccc';
    idCell.style.padding = '8px';
    row.appendChild(idCell);

    // Name (concatenate given + family)
    const nameCell = document.createElement('td');
    if (patient.name && patient.name.length > 0) {
      const given = patient.name[0].given ? patient.name[0].given.join(' ') : '';
      const family = patient.name[0].family || '';
      nameCell.textContent = `${given} ${family}`.trim();
    } else {
      nameCell.textContent = '';
    }
    nameCell.style.border = '1px solid #ccc';
    nameCell.style.padding = '8px';
    row.appendChild(nameCell);

    // Gender
    const genderCell = document.createElement('td');
    genderCell.textContent = patient.gender || '';
    genderCell.style.border = '1px solid #ccc';
    genderCell.style.padding = '8px';
    row.appendChild(genderCell);

    // Birth Date
    const birthCell = document.createElement('td');
    birthCell.textContent = patient.birthDate || '';
    birthCell.style.border = '1px solid #ccc';
    birthCell.style.padding = '8px';
    row.appendChild(birthCell);

    tbody.appendChild(row);
  });

  table.appendChild(tbody);
  container.appendChild(table);
}

  	</script>
  >
}

/*
ClassMethod DisplayScreens()
{
	Set iter =##class(MyFHIR.Web.Utils).GetScreens().%GetIterator()
	W !
	While iter.%GetNext(,.screen) {
		Write "<a href="_screen.%Get("cls")_"?url="_%request.Data("url",1)_" target=""_blank"">"_screen.%Get("screen")_"</a>"
	}
}*/
ClassMethod OnPreHTTP() As %Boolean
{
	#dim %session As %CSP.Session
	K ^CacheTemp(%session.SessionId)
	If $G(%request.Data("id",1))="" {
		Set %response.Redirect=..#HomeScreenCls
		Return 0
	}
	Return 1
}

ClassMethod GetResourceDatas(pResource As %String, pKey) [ CodeMode = expression ]
{
$G(^CacheTemp(%session.SessionId,pResource,pKey),0)
}

ClassMethod SetFHIRServerIntoSession(FHIRServerId)
{
	Set %session.Data("fhirServerUrl") =##class(FHIRSeek.FHIR.Utils).GetFHIRUrl(FHIRServerId)
	Set %session.Data("fullUrl") =##class(FHIRSeek.FHIR.Utils).FullHttpUrl(FHIRServerId)
}

ClassMethod ValidateAuth(FHIRServerId) [ CodeMode = expression ]
{
##class(FHIRSeek.FHIR.Utils).ValidateAuth(##class(FHIRSeek.Web.Base).DecodeDecrypt($TR(FHIRServerId,"'")))
}

XData css1
{
<data><![CDATA[ body {margin: 0;display: flex;font-family: Arial, sans-serif;}#sidebar {width: 250px;background-color: #f4f4f4;border-right: 1px solid #ccc;padding: 10px;height: 100vh;overflow-y: auto;}#main {flex-grow: 1;padding: 20px;}.resource-item {padding: 5px;border-bottom: 1px solid #ddd;cursor: pointer;}.resource-item:hover {background-color: #e0e0e0;} #resourceList{padding:5px; cursor: pointer;}]]></data>
}

XData css2
{
<data><![CDATA[ body {margin: 0;display: flex;font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;} #sidebar {width: 260px;background-color: #2c3e50;color: #ecf0f1;padding: 15px;height: 100vh;overflow-y: auto;border-right: 1px solid #34495e;box-shadow: 2px 0 5px rgba(0, 0, 0,0.1);} #sidebar h3 {margin-top: 0;padding-bottom: 10px;border-bottom: 1px solid #34495e;font-size: 1.2em;} .resource-item {display: flex;justify-content: space-between;align-items: center;padding: 8px 12px;margin-bottom: 5px;border-radius: 4px;transition: background-color 0.2s ease;cursor: pointer;} .resource-item:hover {background-color: #34495e;} .resource-name {flex-grow: 1;} .resource-count {color: #f39c12;font-weight: bold;font-size: 0.95em;margin-left: 10px;} #main {flex-grow: 1;padding: 30px;background-color: #ecf0f1;}]]></data>
}

XData css
{
<data><![CDATA[  body {margin: 0;display: flex;font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;height: 100vh;overflow: hidden;} #sidebar {width: 260px; background-color: #2c3e50; color: #ecf0f1; padding: 15px; height: 100%; overflow-y: auto; border-right: 1px solid #34495e; box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1); resize: horizontal; } #resizer { width: 5px; cursor: ew-resize; background-color: #34495e; } #main { flex-grow: 1; padding: 30px; background-color: #ecf0f1; overflow: auto; } #sidebar h3 { margin-top: 0; padding-bottom: 10px; border-bottom: 1px solid #34495e; font-size: 1.2em; } .resource-item { display: flex; justify-content: space-between; align-items: center; padding: 8px 12px; margin-bottom: 5px; border-radius: 4px; transition: background-color 0.2s ease; cursor: pointer; } .resource-item:hover { background-color: #34495e; } .resource-name { flex-grow: 1; } .resource-count { color: #f39c12; font-weight: bold; font-size: 0.95em; margin-left: 10px; } #searchBox { width: 100%; padding: 8px; margin-bottom: 10px; border-radius: 4px; border: none; font-size: 1em; border: none;background-color: inherit; border-bottom: 2px solid white; color: white;} table { border-collapse: collapse; width: 100%;  } th, td { border: 1px solid #ccc; padding: 4px; word-break: break-word; max-width: 300px; }  ]]></data>
}

}
