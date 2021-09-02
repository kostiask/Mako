pragma solidity >=0.4.22 <0.9.0;

contract Ontology {

    mapping(string => string[]) public ontologies;

    constructor() public {
    }

    function upload_ontology(string memory _ontology_IRI, string memory _ontology_terms) public {
        string[] memory tmp = split(_ontology_terms);
        // if(ontologies[_ontology_IRI].length > 0){
        //     for(uint256 i = 0; i < tmp.length; i++){
        //         ontologies[_ontology_IRI].push(tmp[i]) - 1;
        //     }
        // }
        // else {
            ontologies[_ontology_IRI] = tmp;
        // }
    }

    function check_rdf(string memory _ontology_IRI, string memory _rdf_terms) public view returns(string memory){
        if(ontologies[_ontology_IRI].length > 0){
            string memory str = "";
            string[] memory rdfTerms = split(_rdf_terms);
            for(uint256 i = 0; i < rdfTerms.length; i++){
                for(uint j = 0; j < ontologies[_ontology_IRI].length; j++){
                    if(bytes(rdfTerms[i]).length == bytes(ontologies[_ontology_IRI][j]).length){
                        string memory tmp = ontologies[_ontology_IRI][j];
                        if(keccak256(bytes(rdfTerms[i])) == keccak256(bytes(tmp))){
                            str = string(abi.encodePacked(str, rdfTerms[i]));
                            break;
                        }
                    } 
                }
            }
            return str;
        } else {
            return "ontology not found";
        }
    }

    function split(string memory _ontology_terms) private pure returns(string[] memory){
        uint256 ile = 0; 
        bytes memory stringAsBytesArray = bytes(_ontology_terms);

        for(uint256 i = 0; i < stringAsBytesArray.length; i++){
            if(stringAsBytesArray[i] == '<'){
                ile++;
            }
        }

        string[] memory array = new string[](ile);
        ile = 0;
        uint256 count = 0;
        bytes memory tmp;

        for(uint256 i = 0; i < stringAsBytesArray.length; i++){
            if(count == 0){
                for(uint256 j = i; j < stringAsBytesArray.length; j++){
                    if(stringAsBytesArray[j] != '>'){
                        count++;
                    } else {
                        count++;
                        tmp = new bytes(count);
                        count = 0;
                        break;
                    }
                }
            }
            if(stringAsBytesArray[i] != '>'){
                tmp[count++] = stringAsBytesArray[i];
            } else {
                tmp[count++] = stringAsBytesArray[i];
                array[ile++] = string(tmp);
                count = 0;
            }
        }

        return array;
    }

}
