// Declare variables for getting the xml file for the XSL transformation (folio_xml) and to load the image in IIIF on the page in question (number).
let tei = document.getElementById("folio");
let tei_xml = tei.innerHTML;
let extension = ".xml";
let folio_xml = tei_xml.concat(extension);
let page = document.getElementById("page");
let pageN = page.innerHTML;
let number = Number(pageN);

// Loading the IIIF manifest
var mirador = Mirador.viewer({
  "id": "my-mirador",
  "manifests": {
    "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json": {
      provider: "Bodleian Library, University of Oxford"
    }
  },
  "window": {
    allowClose: false,
    allowWindowSideBar: true,
    allowTopMenuButton: false,
    allowMaximize: false,
    hideWindowTitle: true,
    panels: {
      info: false,
      attribution: false,
      canvas: true,
      annotations: false,
      search: false,
      layers: false,
    }
  },
  "workspaceControlPanel": {
    enabled: false,
  },
  "windows": [
    {
      loadedManifest: "https://iiif.bodleian.ox.ac.uk/iiif/manifest/53fd0f29-d482-46e1-aa9d-37829b49987d.json",
      canvasIndex: number,
      thumbnailNavigationPosition: 'off'
    }
  ]
});


// function to transform the text encoded in TEI with the xsl stylesheet "Frankenstein_text.xsl", this will apply the templates and output the text in the html <div id="text">
function documentLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_text.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("text");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }
  
// function to transform the metadate encoded in teiHeader with the xsl stylesheet "Frankenstein_meta.xsl", this will apply the templates and output the text in the html <div id="stats">
  function statsLoader() {

    Promise.all([
      fetch(folio_xml).then(response => response.text()),
      fetch("Frankenstein_meta.xsl").then(response => response.text())
    ])
    .then(function ([xmlString, xslString]) {
      var parser = new DOMParser();
      var xml_doc = parser.parseFromString(xmlString, "text/xml");
      var xsl_doc = parser.parseFromString(xslString, "text/xml");

      var xsltProcessor = new XSLTProcessor();
      xsltProcessor.importStylesheet(xsl_doc);
      var resultDocument = xsltProcessor.transformToFragment(xml_doc, document);

      var criticalElement = document.getElementById("stats");
      criticalElement.innerHTML = ''; // Clear existing content
      criticalElement.appendChild(resultDocument);
    })
    .catch(function (error) {
      console.error("Error loading documents:", error);
    });
  }

  // Initial document load
  documentLoader();
  statsLoader();
  // Event listener for sel1 change
  function selectHand(event) {
  var visible_mary = document.getElementsByClassName('#MWS');
  var visible_percy = document.getElementsByClassName('#PBS');
  // Convert the HTMLCollection to an array for forEach compatibility
  var MaryArray = Array.from(visible_mary);
  var PercyArray = Array.from(visible_percy);
    if (event.target.value == 'both') {
   MaryArray.forEach(element => {
      element.style.color = 'black'
    });
    PercyArray.forEach(element => {
      element.style.color = 'black'
    });
    } else if (event.target.value == 'Mary') {
    MaryArray.forEach(element => {
      element.style.color = 'red'
    });
    PercyArray.forEach(element => {
      element.style.color = 'black'
    }) 
    } else {
    MaryArray.forEach(element => {
      element.style.color = 'black'
    })
    PercyArray.forEach(element => {
      element.style.color = 'red'
    })  
    }
  }
// write another function that will toggle the display of the deletions by clicking on a button
// EXTRA: write a function that will display the text as a reading text by clicking on a button or another dropdown list, meaning that all the deletions are removed and that the additions are shown inline (not in superscript)
document.getElementById('toggleDeletionsButton').addEventListener('click', toggleDeletions);
function toggleDeletions() {
  var deletions = document.getElementsByTagName('del'); // Get all <del> elements
  var deletionsArray = Array.from(deletions);

  deletionsArray.forEach(function(element) {
    // Check if the element is currently displayed by checking computed style
    var currentDisplay = window.getComputedStyle(element).display;

    if (currentDisplay === "none") {
      element.style.display = "inline"; // Show the element (using inline as it's a block-level element)
    } else {
      element.style.display = "none"; // Hide the element
    }
  });
}

document.getElementById('nextPageButton').addEventListener('click', function() {
  const currentPage = window.location.pathname.split('/').pop().replace('.html', '');
  const suffixes = ['v', 'r'];
  const currentBase = currentPage.slice(0, -1); // e.g., '21' from '21v'
  const currentSuffix = currentPage.slice(-1); // e.g., 'v' from '21v'

  let nextSuffix = '';
  if (currentSuffix === 'v') {
      nextSuffix = 'r';
  } else if (currentSuffix === 'r') {
      nextSuffix = 'v';
  }

  let nextPage = currentBase + nextSuffix;

  if (nextSuffix === 'r' && currentSuffix === 'v') {
      nextPage = (parseInt(currentBase) + 1) + 'r'; 
  }

  const nextPageUrl = nextPage + '.html';
  window.location.href = nextPageUrl;
});

document.getElementById('previousPageButton').addEventListener('click', function() {
  const currentPage = window.location.pathname.split('/').pop().replace('.html', '');
  const suffixes = ['v', 'r'];
  const currentBase = currentPage.slice(0, -1); 
  const currentSuffix = currentPage.slice(-1);

  let previousSuffix = '';
  if (currentSuffix === 'v') {
    previousSuffix = 'r';}
  else if (currentSuffix === 'r'){
    previousSuffix = 'v';}
  
  let previousPage = currentBase + previousSuffix;

  if (previousSuffix === 'v' && currentSuffix === 'r') {
      previousPage = (parseInt(currentBase) -  1) + 'v';
  }

  const previousPageUrl = previousPage + '.html';

  window.location.href = previousPageUrl;
});


document.getElementById('toggleNotesButton').addEventListener('click', toggleNotes);

function toggleNotes() {
  var notes = document.querySelectorAll('.editorial'); 
  notes.forEach(function(element) {
    if (element.style.display === "none" || window.getComputedStyle(element).display === "none") {
      element.style.display = "block";
    } else {
      element.style.display = "none"; 
    }
  });
}