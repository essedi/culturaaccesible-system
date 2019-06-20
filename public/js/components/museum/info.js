Class('Museum.Info', {

    Extends: Component,

    initialize: function() {
        Museum.Info.Super.call(this, 'museum-info');
        this.newButton = document.getElementById('newMuseum');
        this.exhibitionButton = document.getElementById('action');
        this.exhibitionButton.addEventListener('started', this.goToNewExhibition.bind(this));
        this.newButton.addEventListener('createMuseum', this.goToNewMuseum.bind(this));
        this.element.addEventListener('edit', this.goToEditForm.bind(this));
        
        this.element.addEventListener('delete', this.showDeleteAlert.bind(this));
        this.element.addEventListener('delete.confirmation', this.delete.bind(this));
        this.alert = document.getElementById('alert');
        this.getMuseum();
    },

    goToNewMuseum: function() {
        window.location = '/museum';
    },

    goToNewExhibition: function() {
        window.location = '/home';
    },

    render: function(museum) {
        this.element.museumData = museum;
        this.element.visibility = 'show';

    },

    getMuseum: function() {
        var id = this.loadShortUrlData(3);
        var payload = {'id': id};
        Bus.publish('museum.retrieve', payload);
    },

    goToEditForm: function() {
        var museumId = this.loadShortUrlData(3);
        window.location = '/museum/' + museumId + '/edit';
    },
    
    delete: function(event) {
        var museum = event.detail;
        var payload = { 'id': museum.id };
        Bus.publish('museum.delete', payload);
        // set message here
        window.location = '/museum';

    },

    showDeleteAlert: function() {
        this.alert.visibility = 'show';
    },


    loadShortUrlData: function(index) {
        var urlString = window.location.href;
        var regexp = /\/(museum)(\/)(.*)/;
        var data = regexp.exec(urlString)[index];
        return data;
    },

    subscribe: function() {
        Bus.subscribe('museum.retrieved', this.render.bind(this));
        Bus.subscribe('museum.deleted', this.render.bind(this));

    }

});
