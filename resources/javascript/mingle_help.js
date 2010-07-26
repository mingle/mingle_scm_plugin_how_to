// Copyright (c) 2010 ThoughtWorks Inc., licensed under MIT license 

function toggleCollapse(heading_element, placeholder) {
	if (heading_element.hasClassName('collapsed-heading')) {
		heading_element.removeClassName('collapsed-heading');
		heading_element.addClassName('collapsible-heading');
		heading_element.nextSiblings()[0].removeClassName('collapsed');
	} else {
		heading_element.removeClassName('collapsible-heading');
		heading_element.addClassName('collapsed-heading');
		heading_element.nextSiblings()[0].addClassName('collapsed');
	}
}
