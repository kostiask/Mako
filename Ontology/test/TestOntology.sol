pragma solidity >=0.4.22 <0.9.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Ontology.sol";

contract TestOntology {

	Ontology ontology = Ontology(DeployedAddresses.Ontology());

	function testAddingTermsWithANewIRI() public {

		string memory ontology_IRI = "IRI_1";
		string memory ontology_terms = "<1234><5678><qwer><asdf><zxcv>";
		ontology.upload_ontology(ontology_IRI,ontology_terms);
	
		Assert.equal("<1234>", ontology.ontologies(ontology_IRI,0),"Expected value '<1234>' for term number 0 with address 'IRI_1'");
		Assert.equal("<5678>", ontology.ontologies(ontology_IRI,1),"Expected value '<5678>' for term number 1 with address 'IRI_1'");
		Assert.equal("<qwer>", ontology.ontologies(ontology_IRI,2),"Expected value '<qwer>' for term number 2 with address 'IRI_1'");
		Assert.equal("<asdf>", ontology.ontologies(ontology_IRI,3),"Expected value '<asdf>' for term number 3 with address 'IRI_1'");
		Assert.equal("<zxcv>", ontology.ontologies(ontology_IRI,4),"Expected value '<zxcv>' for term number 4 with address 'IRI_1'");
	}

	function testAddingTermsOverAnExistingIRI() public {

		string memory ontology_IRI = "IRI_1";
		string memory ontology_terms = "<kostia><masha><sasha><kasha><car>";
		ontology.upload_ontology(ontology_IRI,ontology_terms);

		// Assert.equal("<1234>", ontology.ontologies(ontology_IRI,0),"Expected value '<1234>' for term number 0 with address 'IRI_1'");
		// Assert.equal("<5678>", ontology.ontologies(ontology_IRI,1),"Expected value '<5678>' for term number 1 with address 'IRI_1'");
		// Assert.equal("<qwer>", ontology.ontologies(ontology_IRI,2),"Expected value '<qwer>' for term number 2 with address 'IRI_1'");
		// Assert.equal("<asdf>", ontology.ontologies(ontology_IRI,3),"Expected value '<asdf>' for term number 3 with address 'IRI_1'");
		// Assert.equal("<zxcv>", ontology.ontologies(ontology_IRI,4),"Expected value '<zxcv>' for term number 4 with address 'IRI_1'");
		Assert.equal("<kostia>", ontology.ontologies(ontology_IRI,0),"Expected value '<kostia>' for term number 5 with address 'IRI_1'");
		Assert.equal("<masha>", ontology.ontologies(ontology_IRI,1),"Expected value '<masha>' for term number 6 with address 'IRI_1'");
		Assert.equal("<sasha>", ontology.ontologies(ontology_IRI,2),"Expected value '<sasha>' for term number 7 with address 'IRI_1'");
		Assert.equal("<kasha>", ontology.ontologies(ontology_IRI,3),"Expected value '<kasha>' for term number 8 with address 'IRI_1'");
		Assert.equal("<car>", ontology.ontologies(ontology_IRI,4),"Expected value '<car>' for term number 9 with address 'IRI_1'");
	}

	function testCheckRdfOntologyNotFound() public {
		string memory ontology_IRI = "IRI_2";
		string memory rdf_terms = "<1234><5678><qwer><asdf><zxcv>";
		string memory result = ontology.check_rdf(ontology_IRI,rdf_terms);

		Assert.equal("ontology not found", result, "Expected 'ontology not found'");
	}

	function testCheckRdfOntology() public {
		string memory ontology_IRI = "IRI_1";
		string memory rdf_terms = "<kasha><poiu><mnbv><kostia><edcf>";
		string memory result = ontology.check_rdf(ontology_IRI,rdf_terms);

		Assert.equal("<kasha><kostia>", result, "Two matches expected: '<1234><kostia>'");
	}

}