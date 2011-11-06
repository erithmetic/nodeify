// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

var alpha = require('./alpha'),
    beta = require('./models/beta'),
    gamma = require('gamma'),
    delta = require('lib_files/delta'),
    epsilon = require('epsilon'),
    zeta = require('vendor_files/zeta');

alpha();
beta();
gamma();
delta();
epsilon();
zeta();
