
App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    return await App.initWeb3();
  },

  initWeb3: async function() {
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        await window.ethereum.enable();
      } catch (error) {
        console.error("User denied account access")
      }
    }
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
    }
    web3 = new Web3(App.web3Provider);
    return App.initContract();
  },

  initContract: async function() {
    const data = await $.getJSON('src/Ontology.json');
    const rdf = new web3.eth.Contract(
      data.abi,
      "0x7105A11e8487BfaF8c02aA6A7cdA5283f971107c"
      );
    rdf.setProvider(App.web3Provider);
    App.contracts.RDF = rdf;
    return App.bindEvents();
  },


  bindEvents: function() {
    $(document).on('click', '#send1', App.upload_ontology);
    $(document).on('click', '#send2', App.check_rdf);
  },

  upload_ontology: function() {
    text1 = $('#index1').val();
    
    var address = $('#address1').val();

    event.preventDefault();
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];
      var data1 = new Date();
      console.log(data1.toLocaleTimeString() + " Run upload...");
      $('#status1').text("Run upload...");
      App.contracts.RDF.methods.upload_ontology(address,text1).send({from: account,gas: 17000000000}).then(function(){
        var data2 = new Date()
        console.log(data2.toLocaleTimeString() + " Ontology upload to smart contract");
        $('#status1').text("Ontology upload to smart contract.");
      });
    });
  },

  check_rdf: function() {
    text2 = $('#index2').val();
    event.preventDefault();
    var address = $('#address2').val();
    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];
      var data1 = new Date();
      console.log(data1.toLocaleTimeString() + " Run check...");
      $('#status2').text("Looking for matches...");
      App.contracts.RDF.methods.check_rdf(address,text2).call().then(function(result){
        var data2 = new Date();
        if(result.length === 0){
          result = "No matches."
        }
        console.log(data2.toLocaleTimeString() + " Result: " + result);
        $('#status2').text("Search is over.");
        $('#index3').val(result);
      });
    });
  },


};

$(function() {
  $(window).load(function() {
    App.init();
  });
});

