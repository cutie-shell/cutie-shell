import QtQuick

Item {
	property var row1_model: row1
	property var row1_model_shift: row1_shift
	property var row1B_model: row1B

	property var row2_model: row2
	property var row2B_model: row2B 

	property var row3_model: row3 
	property var row3B_model: row3B 

	property var row4_model: row4
	property var row4B_model: row4B
	
	property var row5_model: row5
	property var row5_model_shift: row5_shift

	property var layout: 'English US'

	ListModel {
		id: row1
		ListElement{displayText: '1'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '2'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '3'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '4'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '5'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '6'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '7'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '8'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '9'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '0'; keyWidth: 1; capitalization: false;}
	}

	ListModel {
		id: row1_shift
		ListElement{displayText: '!'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '@'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '#'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '$'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '%'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '^'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '&'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '*'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '('; keyWidth: 1; capitalization: false;}
		ListElement{displayText: ')'; keyWidth: 1; capitalization: false;}
	}

	ListModel {
		id: row1B
		ListElement{displayText: '\u21E5'; keyWidth: 1.8; capitalization: false;}
		ListElement{displayText: 'Ctrl'; keyWidth: 1.4; capitalization: false;}
		ListElement{displayText: 'Alt'; keyWidth: 1.4; capitalization: false;}
		ListElement{displayText: '\u21D1'; keyWidth: 1.35; capitalization: false;}
		ListElement{displayText: '\u21D3'; keyWidth: 1.35; capitalization: false;}
		ListElement{displayText: '\u21D0'; keyWidth: 1.35; capitalization: false;}
		ListElement{displayText: '\u21D2'; keyWidth: 1.35; capitalization: false;}
	}

	ListModel {
		id: row2
		ListElement{displayText: 'q'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'w'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'e'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'r'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 't'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'y'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'u'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'i'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'o'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'p'; keyWidth: 1; capitalization: true;}
	}

	ListModel {
		id: row2B
		ListElement{displayText: '*'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '-'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '+'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '"'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '<'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '>'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: "'"; keyWidth: 1; capitalization: false;}
		ListElement{displayText: ':'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: ';'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '~'; keyWidth: 1; capitalization: false;}
	}

	ListModel {
		id: row3
		ListElement{displayText: 'a'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 's'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'd'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'f'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'g'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'h'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'j'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'k'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'l'; keyWidth: 1; capitalization: true;}
	}

	ListModel {
		id: row3B
		ListElement{displayText: '='; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '$'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '€'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '£'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '₵'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '¥'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '§'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '['; keyWidth: 1; capitalization: false;}
		ListElement{displayText: ']'; keyWidth: 1; capitalization: false;}
	}

	ListModel {
		id: row4
		ListElement{displayText: '\u21E7'; keyWidth: 1.5; capitalization: false;}
		ListElement{displayText: 'z'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'x'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'c'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'v'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'b'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'n'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: 'm'; keyWidth: 1; capitalization: true;}
		ListElement{displayText: '\u21E6'; keyWidth: 1.5; capitalization: false;}
		
	}

	ListModel {
		id: row4B
		ListElement{displayText: '\u21E7'; keyWidth: 1.5; capitalization: false;}
		ListElement{displayText: '_'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '`'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '{'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '}'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '\u2216'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '|'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '™'; keyWidth: 1; capitalization: false;}
		ListElement{displayText: '\u21E6'; keyWidth: 1.5; capitalization: false;}
		
	}

	ListModel {
		id: row5
		ListElement{displayText: '-'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: ','; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: ''; keyWidth: 4.7; capitalization: false;}
		ListElement{displayText: '.'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: '/'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: '\u21B5'; keyWidth: 1.7; capitalization: false;}
	}

	ListModel {
		id: row5_shift
		ListElement{displayText: '_'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: '<'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: ''; keyWidth: 4.7; capitalization: false;}
		ListElement{displayText: '>'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: '?'; keyWidth: 0.9; capitalization: false;}
		ListElement{displayText: '\u21B5'; keyWidth: 1.7; capitalization: false;}
	}
}
