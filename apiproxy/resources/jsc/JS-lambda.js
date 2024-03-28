/* globals print */
/* globals context */
/* jslint latedef:false */
// Adapted from: https://github.com/aws/aws-sdk-js/blob/master/lib/signers/v4.js

// Get KVM values
const lambda_key = context.getVariable('private.lambda_key');
const lambda_region = context.getVariable('lambda_region');
const lambda_service = context.getVariable('lambda_service');

// Get other values
const algorithm = context.getVariable('algorithm');
const requestType = context.getVariable('requestType');
const amzDate = context.getVariable('amzDate');
const amzDatetime = context.getVariable('amzDatetime');
const method = context.getVariable('request.verb');
// A bit of a hack
var path = context.getVariable('proxy.pathsuffix');
if( path === '' ) {
    path = '/';
}
var queryParams = context.getVariable("request.querystring");
const body = context.getVariable('request.content');

// Create array, convert to lowercase and sort
const hs = String(context.getVariable('request.headers.names'));
const headersArray = hs.substring(1, hs.length - 1).split(new RegExp(', ', 'g'));
var headersSorted = [];
headersArray.forEach(function(header) {
    headersSorted.push(header.toLowerCase());
});
headersSorted.sort();

// Calculated values
function stringToSign() {
  var parts = [];
  parts.push(algorithm);
  parts.push(amzDatetime);
  parts.push(credentialString());
  parts.push(hexEncodedHash(canonicalString()));
  return parts.join('\n');
}

// https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
function canonicalString() {
  var parts = [];
  parts.push(method);
  parts.push(path);                         // this is e.g. "/pathsuffix/resource"
  parts.push(canonicalQueryParams());       // not supported here
  parts.push(canonicalHeaders() + '\n');    // need empty line after headers
  parts.push(signedHeaders());
  parts.push(hexEncodedBodyHash());
  return parts.join('\n');
}

// Needs to check for empty or invalid values
function canonicalHeaders() {
  var parts = [];
  headersSorted.forEach(function(header) {
    if (isSignableHeader(header)) {
      value = context.getVariable('request.header.' + header);
      parts.push(header.toLowerCase() + ':' + canonicalHeaderValues(value.toString())); 
    } 
  });
  return parts.join('\n');
}

function canonicalHeaderValues(values) {
  return values.replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
}

function canonicalQueryParams() {
    // Expects params to be properly URL encoded, just sort them and re-join
    return queryParams === '' ? '' : queryParams.split('&').sort().join('&');

    // Does this properly handle both unencoded and encoded?
    // decode an unencoded param (e.g. "What the") results in "What the" then gets encoded to "What%20the"
    // decode an encoded param (e.g. "What%20the") restules in "What the" then gets encoded to "What%20the"
    // Is there any value in doing this? curl already encodes the params, perhaps if a client doesn't do that
    // This seems to work during testing locally, but causes bad signature
    // return queryParams === '' ? '' : encodeURI(decodeURI(queryParams.split('&').sort().join('&')));
}

function signedHeaders() {
  var parts = [];
  headersSorted.forEach(function(header) {
    if (isSignableHeader(header)) {
        parts.push(header);
    }
  });
  return parts.join(';');
}

function credentialString() {
  return [amzDate,lambda_region,lambda_service,requestType].join('/');
}

function hexEncodedHash(string) {
    var _sha256 = crypto.getSHA256();
    _sha256.update(string);
    var _hashed_token = _sha256.digest();
    return _hashed_token;
}

// not supported here - only for gets for now
function hexEncodedBodyHash() {
  return hexEncodedHash('');
}

unsignableHeaders = [
    'authorization',
    'content-type',
    'content-length',
    'user-agent',
    'expect',
    'x-amzn-trace-id'
];

function isSignableHeader(key) {
if (key.toLowerCase().indexOf('x-amz-') === 0) return true;
    return unsignableHeaders.indexOf(key) < 0;
}

// Debug
// print("canonicalHeaders: " + canonicalHeaders());
// print("canonicalQueryParams: " + canonicalQueryParams());
// print("canonicalString: " + canonicalString());
// End Debug
context.setVariable("requestPathsuffix", path);
context.setVariable("credentialString", credentialString());
context.setVariable("signedHeaders", signedHeaders());
context.setVariable("stringToSign", stringToSign());

