(function _StringTools_s_() {

'use strict';

/**
 * Collection of sophisticated routines for operations on Strings. StringsToolsExtra leverages analyzing, parsing and formatting of String for special purposes.
  @module Tools/base/l5/StringTools
  @extends Tools
*/

/**
 * @file StringTools.s.
 */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wArraySorted' );
  _.include( 'wArraySparse' );
  _.include( 'wBlueprint' );

}

/**
 * Collection of sophisticated routines for operations on Strings.
  @namespace Tools.StringTools
  @module Tools/base/l5/StringTools
  @augments wTools
*/

//

let Self = _global_.wTools;
let _ = _global_.wTools;

let _ArraySlice = Array.prototype.slice;
let _FunctionBind = Function.prototype.bind;
let _ObjectToString = Object.prototype.toString;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

// let __assert = _.assert;
let _arraySlice = _.longSlice;
let strType = _.strType;

_.assert( _.routineIs( _.sorted.addOnce ) );

// --
//
// --

// function strDecamelize( o )
// {
//
//
// }
//
// strDecamelize.defaults =
// {
//   src : null,
//   delimeter : '-',
// }

//

/**
 * Converts string to camelcase using special pattern.
 * If function finds character from this( '.','-','_','/' ) list before letter,
 * it replaces letter with uppercase version.
 * For example: '.an _example' or '/an -example', method converts string to( 'An Example' ). *
 *
 * @param {string} srcStr - Source string.
 * @returns {string} Returns camelcase version of string.
 *
 * @example
 * //returns aBCD
 * _.strCamelize( 'a-b_c/d' );
 *
 * @example
 * //returns testString
 * _.strCamelize( 'test-string' );
 *
 * @function  strCamelize
 * @throws { Exception } Throws a exception if( srcStr ) is not a String.
 * @throws { Exception } Throws a exception if no argument provided.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strCamelize( srcStr )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( srcStr ) );

  let result = srcStr;
  let regexp = /\.\w|-\w|_\w|\/\w/g;

  result = result.replace( regexp,function( match )
  {
    return match[ 1 ].toUpperCase();
  });

  return result;
}

//

let _strToTitleRegexp1 = /(?<=\s|^)(?:_|\.)+|(?:_|\.)+(?=\s|$)|^\w(?=[A-Z])/g;
let _strToTitleRegexp2 = /(?:_|\.)+/g;
let _strToTitleRegexp3 = /(\s*[A-za-z][a-z]*)|(\s*[0-9]+)/g;
function strToTitle( srcStr )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( srcStr ) );

  let result = srcStr;

  result = result.replace( _strToTitleRegexp1, '' );
  result = result.replace( _strToTitleRegexp2, ' ' );
  result = result.replace( _strToTitleRegexp3, function( match, g1, g2, offset )
  {
    let g = match;
    if( offset > 0 )
    g = _.strDecapitalize( g );
    if( offset > 0 && g[ 0 ] !== ' ' )
    return ' ' + g;
    else
    return g;
  });

  return result;
}

//

/**
 * Removes invalid characters from filename passed as first( srcStr ) argument by replacing characters finded by
 * pattern with second argument( o ) property( o.delimeter ).If( o.delimeter ) is not defined,
 * function sets value to( '_' ).
 *
 * @param {string} srcStr - Source string.
 * @param {object} o - Object that contains o.
 * @returns {string} Returns string with result of replacements.
 *
 * @example
 * //returns _example_file_name.txt
 * _.strFilenameFor( "'example\\file?name.txt" );
 *
 * @example
 * //returns #example#file#name.js
 * let o = { 'delimeter':'#' };
 * _.strFilenameFor( "'example\\file?name.js",o );
 *
 * @function strFilenameFor
 * @throws { Exception } Throws a exception if( srcStr ) is not a String.
 * @throws { Exception } Throws a exception if( o ) is not a Map.
 * @throws { Exception } Throws a exception if no arguments provided.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strFilenameFor( o )
{
  if( _.strIs( o ) )
  o = { srcString : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.srcString ) );
  _.routineOptions( strFilenameFor,o );

  let regexp = /<|>|:|"|'|\/|\\|\||\&|\?|\*|\n|\s/g;
  let result = o.srcString.replace( regexp,function( match )
  {
    return o.delimeter;
  });

  return result;
}

strFilenameFor.defaults =
{
  srcString : null,
  delimeter : '_',
}

//

/**
 * Replaces invalid characters from variable name `o.src` with special character `o.delimeter`.
 *
 * @description
 * Accepts string as single arguments. In this case executes routine with default `o.delimeter`.
 *
 * @param {Object} o Options map.
 * @param {String} o.src Source string.
 * @param {String} o.delimeter='_' Replacer string.
 *
 * @example
 * _.strVarNameFor( 'some:var');//some_var
 *
 * @returns {String} Returns string with result of replacements.
 * @throws { Exception } Throws a exception if( srcStr ) is not a String.
 * @throws { Exception } Throws a exception if( o ) is not a Map.
 * @throws { Exception } Throws a exception if no arguments provided.
 * @function strVarNameFor
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strVarNameFor( o )
{
  if( _.strIs( o ) )
  o = { src : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.src ) );
  _.routineOptions( strVarNameFor,o );

  let regexp = /\.|\-|\+|<|>|:|"|'|\/|\\|\||\&|\?|\*|\n|\s/g;
  let result = o.src.replace( regexp,function( match )
  {
    return o.delimeter;
  });

  return result;
}

strVarNameFor.defaults =
{
  src : null,
  delimeter : '_',
}

//

/**
 * @summary Html escape symbols map.
 * @enum {String} _strHtmlEscapeMap
 * @module Tools/base/l5/StringTools
 */

let _strHtmlEscapeMap =
{
  '&' : '&amp;',
  '<' : '&lt;',
  '>' : '&gt;',
  '"' : '&quot;',
  '\'' : '&#39;',
  '/' : '&#x2F;'
}

/**
 * Replaces all occurrences of html escape symbols from map {@link module:Tools/base/l5/StringTools~_strHtmlEscapeMap}
 * in source( str ) with their code equivalent like( '&' -> '&amp;' ).
 * Returns result of replacements as new string or original if nothing replaced.
 *
 * @param {string} str - Source string to parse.
 * @returns {string} Returns string with result of replacements.
 *
 * @example
 * //returns &lt;&amp;test &amp;text &amp;here&gt;
 * _.strHtmlEscape( '<&test &text &here>' );
 *
 * @example
 * //returns 1 &lt; 2
 * _.strHtmlEscape( '1 < 2' );
 *
 * @example
 * //returns &#x2F;&#x2F;test&#x2F;&#x2F;
 * _.strHtmlEscape( '//test//' );
 *
 * @example
 * //returns &amp;,&lt;
 * _.strHtmlEscape( ['&','<'] );
 *
 * @example
 * //returns &lt;div class=&quot;cls&quot;&gt;&lt;&#x2F;div&gt;
 * _.strHtmlEscape('<div class="cls"></div>');
 *
 * @function  strHtmlEscape
 * @throws { Exception } Throws a exception if no argument provided.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strHtmlEscape( str )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  return String( str ).replace( /[&<>"'\/]/g, function( s )
  {
    return _strHtmlEscapeMap[ s ];
  });
}

//

/*
qqq : tests required | Dmytro : covered all options
*/

function strSearch( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( strSearch,o );

  /* */

  o.ins = _.arrayAs( o.ins );
  o.ins = _.regexpsMaybeFrom
  ({
    srcStr : o.ins,
    stringWithRegexp : o.stringWithRegexp,
    toleratingSpaces : o.toleratingSpaces,
  });

  if( _.arrayIs( o.excludingTokens ) || _.strIs( o.excludingTokens ) )
  {
    debugger;
    o.excludingTokens = _.path.globsShortToRegexps( o.excludingTokens );
    o.excludingTokens = _.regexpsAny( o.excludingTokens );
  }

  /* */

  let result = [];
  let found = _.strFindAll( o.src, o.ins );

  found.forEach( ( it ) =>
  {

    it.charsRange = it.range;
    it.charsRangeRight = [ o.src.length - it.charsRange[ 0 ], o.src.length - it.charsRange[ 1 ] ];

    let first;
    if( o.determiningLineNumber )
    {
      first = o.src.substring( 0,it.charsRange[ 0 ] ).split( '\n' ).length;
      it.linesRange = [ first, first+o.src.substring( it.charsRange[ 0 ], it.charsRange[ 1 ] ).split( '\n' ).length ];
    }

    if( o.nearestLines )
    if( o.nearestLines )
    it.nearest = _.strLinesNearest
    ({
      src : o.src,
      charsRange : it.charsRange,
      numberOfLines : o.nearestLines,
    }).splits;

    if( o.determiningLineNumber )
    it.linesOffsets = [ first - _.strLinesCount( it.nearest[ 0 ] ) + 1, first, first + _.strLinesCount( it.nearest[ 1 ] ) ];

    if( o.onTokenize )
    {
      let tokens = o.onTokenize( it.nearest.join( '' ) );

      let ranges = _.select( tokens, '*/range/0' );
      let range = [ it.nearest[ 0 ].length, it.nearest[ 0 ].length + it.nearest[ 1 ].length ];
      let having = _.sorted.lookUpIntervalHaving( ranges, range );

      _.assert( ranges[ having[ 0 ] ] <= range[ 0 ] );
      _.assert( having[ 1 ] === ranges.length || ranges[ having[ 1 ] ] >= range[ 1 ] );

      if( o.excludingTokens )
      {
        let tokenNames = _.select( tokens, '*/tokenName' );
        tokenNames = tokenNames.slice( having[ 0 ], having[ 1 ] );
        let pass = _.none( _.regexpTest( o.excludingTokens, tokenNames ) );
        if( !pass )
        return;
      }

    }

    if( !o.nearestSplitting )
    it.nearest = it.nearest.join( '' );
    // it.nearest.join( '' ); // Dmytro : has not influence on the result

    result.push( it );
  });

  return result;
}

strSearch.defaults =
{
  src : null,
  ins : null,
  nearestLines : 3,
  nearestSplitting : 1,
  determiningLineNumber : 0,
  stringWithRegexp : 0,
  toleratingSpaces : 0,
  onTokenize : null,
  excludingTokens : null,
}

//

function strFindAll( src, ins )
{
  let o;

  /* xxx : sync names with _.strLeft / _.strRight */

  if( arguments.length === 2 )
  {
    o = { src : arguments[ 0 ] , ins : arguments[ 1 ] };
  }
  else if( arguments.length === 1 )
  {
    o = arguments[ 0 ];
  }

  if( _.strIs( o.ins ) || _.regexpIs( o.ins ) )
  o.ins = [ o.ins ];

  /* */

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.strIs( o.src ) );
  _.assert( _.arrayLike( o.ins ) || _.objectIs( o.ins ) );
  _.routineOptions( strFindAll, o );

  /* */

  let tokensSyntax = _.tokensSyntaxFrom( o.ins );
  let descriptorsArray = [];
  let execeds = [];
  let closests = [];
  let closestTokenId = -1;
  let closestIndex = o.src.length;
  let currentIndex = 0;

  /* */

  tokensSyntax.idToValue.forEach( ( ins, tokenId ) =>
  {
    // Dmytro : not optimal - double check
    _.assert( _.strIs( ins ) || _.regexpIs( ins ) );

    if( _.regexpIs( ins ) )
    _.assert( !ins.sticky );

    let found = find( o.src, ins, tokenId );
    closests[ tokenId ] = found;
    if( found < closestIndex )
    {
      closestIndex = found
      closestTokenId = tokenId;
    }
  });

  /* */

  while( closestIndex < o.src.length )
  {

    if( o.tokenizingUnknown && closestIndex > currentIndex )
    {
      descriptorFor( o.src, currentIndex, -1 );
    }

    descriptorFor( o.src, closestIndex, closestTokenId );

    closestIndex = o.src.length;
    closests.forEach( ( index, tokenId ) =>
    {
      if( index < currentIndex )
      index = closests[ tokenId ] = find( o.src, tokensSyntax.idToValue[ tokenId ], tokenId );

      _.assert( closests[ tokenId ] >= currentIndex );

      if( index < closestIndex )
      {
        closestIndex = index
        closestTokenId = tokenId;
      }
    });

    _.assert( closestIndex <= o.src.length );
  }

  if( o.tokenizingUnknown && closestIndex > currentIndex )
  {
    descriptorFor( o.src, currentIndex, -1 );
  }

  /* */

  return descriptorsArray;

  /* */

  function find( src, ins, tokenId )
  {
    let result;

    if( _.strIs( ins ) )
    {
      if( !ins.length )
      result = src.length;
      else
      result = findWithString( o.src, ins, tokenId );
    }
    else if( _.regexpIs( ins ) )
    {
      if( ins.source === '(?:)' ) // Dmytro : missed, it's regexp for empty string
      result = src.length;
      else
      result = findWithRegexp( o.src, ins, tokenId );
    }
    else _.assert( 0 );

    _.assert( result >= 0 );
    return result;
  }

  /* */

  function findWithString( src, ins )
  {

    if( !ins.length ) // Dmytro : duplicate from previous subroutine
    return src.length;

    let index = src.indexOf( ins, currentIndex );

    if( index < 0 )
    return src.length;

    return index;
  }

  /* */

  function findWithRegexp( src, ins, tokenId )
  {
    let execed;
    let result = src.length;

    if( currentIndex === 0 || ins.global )
    {

      do
      {

        execed = ins.exec( src );
        if( execed )
        result = execed.index;
        else
        result = src.length;

      }
      while( result < currentIndex );

    }
    else
    {
      execed = ins.exec( src.substring( currentIndex ) );

      if( execed )
      result = execed.index + currentIndex;

    }

    if( execed )
    execeds[ tokenId ] = execed;

    return result;
  }

  /* */

  function descriptorFor( src, index, tokenId )
  {
    let originalIns = tokensSyntax.idToValue[ tokenId ];
    let foundIns;

    if( tokenId === -1 )
    originalIns = src.substring( index, closestIndex );

    if( o.fast )
    {
      let it = [];

      if( _.strIs( originalIns ) )
      {
        foundIns = originalIns;
      }
      else
      {
        let execed = execeds[ tokenId ];
        _.assert( !!execed );
        foundIns = execed[ 0 ];
      }

      it[ 0 ] = index;
      it[ 1 ] = index + foundIns.length;
      it[ 2 ] = tokenId;

      descriptorsArray.push( it );
    }
    else
    {
      let it = Object.create( null );
      let groups;

      if( _.strIs( originalIns ) )
      {
        foundIns = originalIns;
        groups = [];
      }
      else
      {
        let execed = execeds[ tokenId ];
        _.assert( !!execed );
        foundIns = execed[ 0 ];
        groups = _.longSlice( execed, 1, execed.length );
      }

      it.match = foundIns;
      it.groups = groups;
      it.tokenId = tokenId;
      it.range = [ index, index + foundIns.length ];
      it.counter = o.counter;
      it.input = src;

      if( tokensSyntax.idToName && tokensSyntax.idToName[ tokenId ] )
      it.tokenName = tokensSyntax.idToName[ tokenId ];

      descriptorsArray.push( it );
    }

    _.assert( _.strIs( foundIns ) );
    if( foundIns.length > 0 )
    currentIndex = index + foundIns.length;
    else
    currentIndex = index + 1;

    o.counter += 1;
  }

}

strFindAll.defaults =
{
  src : null,
  ins : null,
  fast : 0,
  counter : 0,
  tokenizingUnknown : 0,
}

//

let TokensSyntax = _.blueprint.defineConstructor
({
  idToValue : null,
  idToName : _.define.shallow( [] ),
  nameToId : _.define.shallow( {} ),
  alternatives : _.define.shallow( {} ),
  typed : _.trait.typed(),
});

//

function tokensSyntaxFrom( ins )
{

  if( ins instanceof _.TokensSyntax )
  return ins

  let result = TokensSyntax();

  if( _.strIs( ins ) || _.regexpIs( ins ) )
  ins = [ ins ];

  /* */

  _.assert( arguments.length === 1 );
  _.assert( _.arrayLike( ins ) || _.objectIs( ins ) );

  /* */

  /*
  qqq2 : ins could be also array _.strFindAll( 'some string2', { a : 'some', b : [ 'string1', 'string2' ] } ) cover extension please | Dmytro : covered routines tokensSyntaxFrom and strFindAll
  */

  result.idToValue = ins;
  if( _.mapIs( ins ) )
  {
    result.idToValue = [];
    result.idToName = [];
    let i = 0;
    for( var name in ins )
    {
      let element = ins[ name ];
      if( _.longIs( element ) )
      {
        let alternative = result.alternatives[ name ] = result.alternatives[ name ] || [];
        for( let e = 0 ; e < element.length ; e++ )
        {
          let name2 = name + '_' + element[ e ];
          result.idToValue[ i ] = ins[ name ][ e ]; // Dmytro : better to use local variable 'let element'. Also, maybe, needs check type of element - regexp or string.
          result.idToName[ i ] = name2;
          result.nameToId[ name2 ] = i;
          alternative.push( name2 );
          i += 1;
        }
      }
      else
      {
        result.idToValue[ i ] = ins[ name ]; // Dmytro : better to use local variable 'let element'
        result.idToName[ i ] = name;
        result.nameToId[ name ] = i;
        i += 1;
      }
    }
  }

  return result;
}

//

function _strReplaceMapPrepare( o )
{

  /* verify */

  _.assertMapHasAll( o, _strReplaceMapPrepare.defaults );
  _.assert( arguments.length === 1 );
  _.assert( _.objectIs( o.dictionary ) || _.longIs( o.dictionary ) || o.dictionary === null );
  _.assert( ( _.longIs( o.ins ) && _.longIs( o.sub ) ) || ( o.ins === null && o.sub === null ) );

  /* pre */

  if( o.dictionary )
  {

    o.ins = [];
    o.sub = [];

    if( _.objectIs( o.dictionary ) )
    {
      let i = 0;
      for( let d in o.dictionary )
      {
        o.ins[ i ] = d;
        o.sub[ i ] = o.dictionary[ d ];
        i += 1;
      }
    }
    else
    {
      let i = 0;
      o.dictionary.forEach( ( d ) =>
      {
        let ins = d[ 0 ];
        let sub = d[ 1 ];
        _.assert( d.length === 2 );
        _.assert( !( _.arrayIs( ins ) ^ _.arrayIs( sub ) ) );
        if( _.arrayIs( ins ) )
        {
          _.assert( ins.length === sub.length )
          for( let n = 0 ; n < ins.length ; n++ )
          {
            o.ins[ i ] = ins[ n ];
            o.sub[ i ] = sub[ n ];
            i += 1;
          }
        }
        else
        {
          o.ins[ i ] = ins;
          o.sub[ i ] = sub;
          i += 1;
        }
      });
    }

    o.dictionary = null;
  }

  /* verify */

  _.assert( !o.dictionary );
  _.assert( o.ins.length === o.sub.length );

  if( Config.debug )
  {
    o.ins.forEach( ( ins ) => _.assert( _.strIs( ins ) || _.regexpIs( ins ) ), 'Expects String or RegExp' );
    o.sub.forEach( ( sub ) => _.assert( _.strIs( sub ) || _.routineIs( sub ) ), 'Expects String or Routine' );
  }

  return o;
}

_strReplaceMapPrepare.defaults =
{
  dictionary : null,
  ins : null,
  sub : null,
}

//

/**
 * Routine strReplaceAll() searches each occurrence of element of {-ins-} container in source string {-src-}
 * and replaces it to corresponding element in {-sub-} container.
 * Returns result of replacements as new string or original string if no matches found in source( src ).
 *
 * Routine can be called in three different ways.
 *
 * Three arguments:
 * @param { String } src - Source string to parse.
 * @param { String|RegExp|Long } ins - String or regexp pattern to search in source string. Also, it can be a
 * set of string and regexp patterns passed as Long. If {-ins-} is a Long, then {-but-} should be long with the
 * same length.
 * @param { String|Long } but - String or a Long with strings to replace occurrences {-ins-}. If {-but-} is a
 * Long, then it should contains only strings and {-ins-} should be a long with the same length.
 *
 * Two arguments:
 * @param { String } src - Source string to parse.
 * @param { Long|Map } dictionary - Long or map that contains pattern/replacement pairs. If {-dictionary-} is a
 * Long, then it looks like [ [ ins1, sub1 ], [ ins2, sub2 ] ], otherwise, it is like { ins1 : sub1, ins2 : sub2 }.
 *
 * One argument:
 * @param { ObjectLike } o - Object, which can contains options:
 * @param { String } o.src - Source string to parse.
 * @param { Long|Map } o.dictionary - Long or map that contains pattern/replacement pairs, transforms to {-o.ins-}
 * and {-o.but-}. If {-dictionary-} is a Long, then it looks like [ [ ins1, sub1 ], [ ins2, sub2 ] ], otherwise, it
 *  is like { ins1 : sub1, ins2 : sub2 }.
 * @param { Long } o.ins - A Long with string or regexp patterns to search in source string {-o.src-}.
 * @param { Long } o.sub - String that replaces found occurrence( ins ).
 * Note. If {-o.ins-} and {-o.sub-} options is used, then {-o.dictionary-} should be not provided, otherwise,
 * {-o.dictionary-} values replace elements of {-o.ins-} and {-o.sub-}
 * @param { BoolLike } o.joining - A parameter which control output value. If {-o.joining-} is true, then routine
 * returns string, otherwise, the array with parsed parts of source string is returned. Default value is 1.
 * @param { Routine } o.onUnknown - A callback, which transforms parts of source string that not found by a pattern.
 * {-o.onUnknown-} accepts three parameters: {-unknown-} - part of string, {-it-} - data structure with information
 * about found pattern in format of routine strFindAll(), {-o-} - the map options.
 * Option {-o.onUnknown-} does not transforms part of source string after last entry of a {-o.ins-} pattern.
 *
 * @example
 * _.strReplaceAll( 'abcdef', 'b', 'w' );
 * //returns 'awcdef'
 *
 * @example
 * _.strReplaceAll( 'abcdef', [ 'b', /d/g, 'f' ], [ 'w', 'x', 'y' ] );
 * //returns 'awcxey'
 *
 * @example
 * _.strReplaceAll( 'abcdef', [ [ 'b', 'w' ], [ 'd', 'x' ], [ /f$/g, 'y' ] ] );
 * //returns 'awcxey'
 *
 * @example
 * _.strReplaceAll( 'abcdef', { 'b' : 'w', 'd' : 'x', 'f' : 'y' } );
 * //returns 'awcxey'
 *
 * @example
 * _.strReplaceAll( { src : 'abcdef', dictionary : [ [ 'b', 'w' ], [ 'd', 'x' ], [ 'f', 'y' ] ] } );
 * //returns 'awcxey'
 *
 * @example
 * _.strReplaceAll( { src : 'abcdef', dictionary : { 'b' : 'w', 'd' : 'x', 'f' : 'y' }, joining : 0 } );
 * //returns [ 'a', 'w', 'c', 'x', 'e', 'y' ]
 *
 * @example
 * _.strReplaceAll( { src : 'abcdefg', ins : [ 'b', 'd', 'f' ], but : [ 'w', 'x', 'y' ], onUnknown : ( e, c, o ) => '|' } );
 * //returns '|w|x|yg'
 *
 * @returns { String|Long } - By default, routine returns string with result of replacements. If map options is used and
 * option {-o.joining-} is false like, then routine returns array with parts of resulted string.
 * @function  strReplaceAll
 * @throws { Error } If arguments.length is less then one or more then three.
 * @throws { Error } If {-src-} or {-o.src-} is not a String.
 * @throws { Error } If {-ins-} is not a String, not a RegExp or not a Long with strings and regexps.
 * @throws { Error } If {-sub-} is not a String or not a Long with strings.
 * @throws { Error } If one of the {-ins-} or {-sub-} is a Long, and the other is not.
 * @throws { Error } If {-ins-} and {-sub-} is Longs, and has different length.
 * @throws { Error } If {-dictionary-} or {-o.dictionary-} is not an Object or Long.
 * @throws { Error } If {-o.onUnknown-} is not a routine or not null.
 * @throws { Error } If map options {-o-} has unnecessary fields.
 * @namespace Tools
 *
 */

/*
qqq : extend coverage | Dmytro : extended
*/

function strReplaceAll( src, ins, sub )
{
  let o;
  let foundArray = [];

  if( arguments.length === 3 )
  {
    o = { src };
    o.dictionary = [ [ ins, sub ] ]
  }
  else if( arguments.length === 2 )
  {
    o = { src : arguments[ 0 ] , dictionary : arguments[ 1 ] };
  }
  else if( arguments.length === 1 )
  {
    o = arguments[ 0 ];
  }
  else
  {
    _.assert( 0 );
  }

  /* verify */

  _.routineOptions( strReplaceAll, o );
  _.assert( _.strIs( o.src ) );
  // _.assert( arguments.length === 1 || arguments.length === 2 || arguments.length === 3 ); // Dmytro : added to checking of arguments

  _._strReplaceMapPrepare( o );

  /* */

  let found = _.strFindAll( o.src, o.ins );
  let result = [];
  let index = 0;

  found.forEach( ( it ) =>
  {
    let sub = o.sub[ it.tokenId ];
    let unknown = o.src.substring( index, it.range[ 0 ] );
    if( unknown )
    if( o.onUnknown )
    unknown = o.onUnknown( unknown, it, o );
    if( unknown !== '' )
    result.push( unknown );
    if( _.routineIs( sub ) )
    sub = sub.call( o, it.match, it );
    // _.assert( _.strIs( sub ) );
    if( sub !== '' )
    result.push( sub );
    index = it.range[ 1 ];
  });

  result.push( o.src.substring( index, o.src.length ) );

  if( o.joining )
  result = result.join( '' )

  return result;
}

strReplaceAll.defaults =
{
  src : null,
  dictionary : null,
  ins : null,
  sub : null,
  joining : 1,
  onUnknown : null,
  // counter : 0,
}

//

var JsTokensDefinition =
{
  'comment/multiline'     : /\/\*(?:\n|.)*?\*\//,
  'comment/singleline'    : /\/\/.*?(?=\n|$)/,
  'string/single'         : /'(?:\\\n|\\'|[^'\n])*?'/,
  'string/double'         : /"(?:\\\n|\\"|[^"\n])*?"/,
  'string/multiline'      : /`(?:\\\n|\\`|[^`])*?`/,
  'whitespace'            : /\s+/,
  'keyword'               : /\b(?:arguments|async|await|boolean|break|byte|case|catch|char|class|const|debugger|default|delete|do|double|else|enum|eval|export|extends|false|final|finally|float|for|function|goto|if|implements|import|in|instanceof|interface|let|long|native|new|null|package|private|protected|public|return|short|static|super|switch|this|throw|throws|transient|true|try|typeof|var|void|volatile|while|with|yield)\b/, // Dmytro : added new keywords and sorted in alphabetic order
  'regexp'                : /\/((?:\\\/|[^\/\n])+?)\/(\w*)/,
  'name'                  : /[a-z_\$][0-9a-z_\$]*/i,
  'number'                : /(?:0x(?:\d|[a-f])+|\d+(?:\.\d+)?(?:e[+-]?\d+)?)/i,
  'parenthes'             : /[\(\)]/,
  'curly'                 : /[{}]/,
  'square'                : /[\[\]]/,
  'punctuation'           : /;|,|\.\.\.|\.|\:|\?|=>|>=|<=|<|>|!==|===|!=|==|=|!|&|<<|>>|>>>|\+\+|--|\*\*|\+|-|\^|\||\/|\*|%|~|\!/,
  'name/function'         : /[a-zA-Z_$][a-zA-Z0-9_$]*(?=\()/, // Dmytro : added
  'number/binary'         : /0[bB][01]+n?/, // Dmytro : added
  'number/octal'          : /0[oO][0-7]+n?/, // Dmytro : added
  'number/hex'            : /0[xX][0-9a-fA-F]+n?/, // Dmytro : added
  'unicodeEscapeSequence' : /u[0-9a-fA-F]{4}/, // Dmytro : added
  'tab'                   : /\t+/, // Dmytro : added
  'comment/jsdoc'         : /\/\*\*(?:\n|.)*?\*\//, // Dmytro : added
}

function strTokenizeJs( o )
{
  if( _.strIs( o ) )
  o = { src : o }

  let result = _.strFindAll
  ({
    src : o.src,
    ins : JsTokensDefinition,
    tokenizingUnknown : o.tokenizingUnknown,
  });

  return result;
}

strTokenizeJs.defaults =
{
  src : null,
  tokenizingUnknown : 0,
}

//

var CppTokensDefinition =
{
  'comment/multiline'     : /\/\*.*?\*\//,
  'comment/singleline'    : /\/\/.*?(?=\n|$)/,
  'string/single'         : /'(?:\\\n|\\'|[^'\n])*?'/,
  'string/double'         : /"(?:\\\n|\\"|[^"\n])*?"/,
  'string/multiline'      : /`(?:\\\n|\\`|[^`])*?`/,
  'whitespace'            : /\s+/,
  'keyword'               : /\b(?:alignas|alignof|and|and_eq|asm|auto|bitand|bitor|bool|break|case|catch|char|char16_t|char32_t|class|compl|const|constexpr|const_cast|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|false|float|for|friend|goto|if|inline|int|long|mutable|namespace|new|noexcept|not|not_eq|nullptr|operator|or|or_eq|private|protected|public|register|reinterpret_cast|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|true|try|typedef|typeid|typename|union|unsigned|using(1)|virtual|void|volatile|wchar_t|while|xor|xor_eq)\b/, // Dmytro : added new keywords and sorted in alphabetic order
  'regexp'                : /\/(?:\\\/|[^\/])*?\/(\w+)/,
  'name'                  : /[a-z_\$][0-9a-z_\$]*/i,
  'number'                : /(?:0x(?:\d|[a-f])+|\d+(?:\.\d+)?(?:e[+-]?\d+)?)/i,
  'parenthes'             : /[\(\)]/,
  'curly'                 : /[{}]/,
  'square'                : /[\[\]]/,
  'punctuation'           : /;|,|\.\.\.|\.|\:|\?|=>|>=|<=|<|>|!=|!=|==|=|!|&|<<|>>|\+\+|--|\*\*|\+|-|\^|\||\/|\*|%|~|\!/,
  'char/literal'          : /(?:L|u|u8|U)?'\w'/, // Dmytro : added
  'tab'                   : /\t+/, // Dmytro : added
}

function strTokenizeCpp( o )
{
  if( _.strIs( o ) )
  o = { src : o }

  let result = _.strFindAll
  ({
    src : o.src,
    ins : JsTokensDefinition,
    tokenizingUnknown : o.tokenizingUnknown,
  });

  return result;
}

strTokenizeCpp.defaults =
{
  src : null,
  tokenizingUnknown : 0,
}

//

/**
 * @summary Splits string into a parts using ranges from ( sparce ) sparce array.
 * @param {String} srcStr - Source string to parse.
 * @param {Array} sparse - Sparse array with ranges.
 * @returns {Array} Returns array with parts of string.
 *
 * @example
 * _.strSubs( 'aabbcc', [  ] );//
 *
 * @function strSubs
 * @throws { Exception } If not enough argumets provided.
 * @throws { Exception } If ( srcStr ) is not a string.
 * @throws { Exception } If ( sparce ) is not a sparce array.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strSubs( srcStr, sparse )
{
  var result = [];

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( srcStr ) );
  _.assert( _.sparse.is( sparse ) );

  debugger;

  _.sparse.eachRange( sparse, ( range ) =>
  {
    result.push( srcStr.substring( range[ 0 ], range[ 1 ] ) );
  });

  return result;
}

//

function strSorterParse( o )
{

  if( arguments.length === 1 )
  {
    if( _.strIs( o ) )
    o = { src : o }
  }

  if( arguments.length === 2 )
  {
    o =
    {
      src : arguments[ 0 ],
      fields : arguments[ 1 ]
    }
  }

  _.routineOptions( strSorterParse, o );
  _.assert( o.fields === null || _.objectLike( o.fields ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let map =
  {
    '>' : 1,
    '<' : 0
  }

  let delimeters = _.mapOwnKeys( map );
  let splitted = _.strSplit
  ({
    src : o.src,
    delimeter : delimeters,
    stripping : 1,
    preservingDelimeters : 1,
    preservingEmpty : 0,
  });

  let parsed = [];

  if( splitted.length >= 2 )
  for( let i = 0; i < splitted.length; i+= 2 )
  {
    let field = splitted[ i ];
    let postfix = splitted[ i + 1 ];

    _.assert( o.fields ? o.fields[ field ] : true, 'Field: ', field, ' is not allowed.' );
    _.assert( _.strIs( postfix ), 'Field: ', field, ' doesn\'t have a postfix.' );

    let valueForPostfix = map[ postfix ];

    if( valueForPostfix !== undefined )
    {
      parsed.push( [ field,valueForPostfix ] )
    }
    else
    {
      _.assert( 0, 'unknown postfix: ', postfix )
    }
  }

  return parsed;
}

strSorterParse.defaults =
{
  src : null,
  fields : null,
}

//

// function jsonParse( o )
// {
//   let result;

//   if( _.strIs( o ) )
//   o = { src : o }
//   _.routineOptions( jsonParse, o );
//   _.assert( arguments.length === 1 );

//   debugger; /* xxx: implement via GDF */

//   try
//   {
//     result = JSON.parse( o.src );
//   }
//   catch( err )
//   {
//     let src = o.src;
//     let position = /at position (\d+)/.exec( err.message );
//     if( position )
//     position = Number( position[ 1 ] );
//     let first = 0;
//     if( !isNaN( position ) )
//     {
//       let nearest = _.strLinesNearest( src, position );
//       first = _.strLinesCount( src.substring( 0, nearest.spans[ 0 ] ) );
//       src = nearest.splits.join( '' );
//     }
//     let err2 = _.err( 'Error parsing JSON\n', err, '\n', _.strLinesNumber( src, first ) );
//     throw err2;
//   }

//   return result;
// }

function jsonParse( o )
{
  let result;

  if( _.strIs( o ) )
  o = { src : o }
  _.routineOptions( jsonParse, o );
  _.assert( arguments.length === 1 );

  let selected = _.Gdf.Select({ in : 'string', out : 'structure', ext : 'json' });
  _.assert( selected.length === 1 );
  let jsonParser = selected[ 0 ];

  result = jsonParser.encode({ data : o.src });

  return result.data;
}

jsonParse.defaults =
{
  src : null,
}

// --
// format
// --

/**
 * Converts string( str ) to array of unsigned 8-bit integers.
 *
 * @param {string} str - Source string to convert.
 * @returns {typedArray} Returns typed array that represents string characters in 8-bit unsigned integers.
 *
 * @example
 * //returns [ 101, 120, 97, 109, 112, 108, 101 ]
 * _.strToBytes( 'example' );
 *
 * @function  strToBytes
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if no argument provided.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strToBytes( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  let result = new U8x( src.length );

  for( let s = 0, sl = src.length ; s < sl ; s++ )
  {
    result[ s ] = src.charCodeAt( s );
  }

  return result;
}

//

 /**
 * @summary Contains metric prefixes.
 * @enum {} _metrics
 * @module Tools/base/l5/StringTools
 */

let _metrics =
{

  '24'  : { name : 'yotta', symbol : 'Y' , word : 'septillion' },
  '21'  : { name : 'zetta', symbol : 'Z' , word : 'sextillion' },
  '18'  : { name : 'exa'  , symbol : 'E' , word : 'quintillion' },
  '15'  : { name : 'peta' , symbol : 'P' , word : 'quadrillion' },
  '12'  : { name : 'tera' , symbol : 'T' , word : 'trillion' },
  '9'   : { name : 'giga' , symbol : 'G' , word : 'billion' },
  '6'   : { name : 'mega' , symbol : 'M' , word : 'million' },
  '3'   : { name : 'kilo' , symbol : 'k' , word : 'thousand' },
  '2'   : { name : 'hecto', symbol : 'h' , word : 'hundred' },
  '1'   : { name : 'deca' , symbol : 'da', word : 'ten' },

  '0'   : { name : ''     , symbol : ''  , word : '' },

  '-1'  : { name : 'deci' , symbol : 'd' , word : 'tenth' },
  '-2'  : { name : 'centi', symbol : 'c' , word : 'hundredth' },
  '-3'  : { name : 'milli', symbol : 'm' , word : 'thousandth' },
  '-6'  : { name : 'micro', symbol : 'μ' , word : 'millionth' },
  '-9'  : { name : 'nano' , symbol : 'n' , word : 'billionth' },
  '-12' : { name : 'pico' , symbol : 'p' , word : 'trillionth' },
  '-15' : { name : 'femto', symbol : 'f' , word : 'quadrillionth' },
  '-18' : { name : 'atto' , symbol : 'a' , word : 'quintillionth' },
  '-21' : { name : 'zepto', symbol : 'z' , word : 'sextillionth' },
  '-24' : { name : 'yocto', symbol : 'y' , word : 'septillionth' },

  range : [ -24,+24 ],

}

/**
 * Returns string that represents number( src ) with metric unit prefix that depends on options( o ).
 * If no options provided function start calculating metric with default options.
 * Example: for number ( 50000 ) function returns ( "50.0 k" ), where "k"- thousand.
 *
 * @param {(number|string)} src - Source object.
 * @param {object} o - conversion options.
 * @param {number} [ o.divisor=3 ] - Sets count of number divisors.
 * @param {number} [ o.thousand=1000 ] - Sets integer power of one thousand.
 * @param {boolean} [ o.fixed=1 ] - The number of digits to appear after the decimal point, example : [ '58912.001' ].
 * Number must be between 0 and 20.
 * @param {number} [ o.dimensions=1 ] - Sets exponent of a number.
 * @param {number} [ o.metric=0 ] - Sets the metric unit type from the map( _metrics ).
 * @returns {string} Returns number with metric prefix as a string.
 *
 * @example
 * //returns "1.0 M"
 * _.strMetricFormat( 1, { metric : 6 } );
 *
 * @example
 * //returns "100.0 "
 * _.strMetricFormat( "100m", { } );
 *
 * @example
 * //returns "100.0 T
 * _.strMetricFormat( "100m", { metric : 12 } );
 *
 * @example
 * //returns "2 k"
 * _.strMetricFormat( "1500", { fixed : 0 } );
 *
 * @example
 * //returns "1.0 M"
 * _.strMetricFormat( "1000000",{ divisor : 2, thousand : 100 } );
 *
 * @example
 * //returns "10.0 h"
 * _.strMetricFormat( "10000", { divisor : 2, thousand : 10, dimensions : 3 } );
 *
 * @function strMetricFormat
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

/* qqq : cover routine strMetricFormat | Dmytro : covered */

function strMetricFormat( number,o )
{

  if( _.strIs( number ) )
  number = parseFloat( number );

  o = _.routineOptions( strMetricFormat, o );

  if( o.metrics === null )
  o.metrics = _metrics;

  _.assert( _.numberIs( number ), '"number" should be Number' );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.objectIs( o ) || o === undefined,'Expects map {-o-}' );
  _.assert( _.numberIs( o.fixed ) );
  _.assert( o.fixed <= 20 );

  let original = number;

  if( o.dimensions !== 1 )
  o.thousand = Math.pow( o.thousand,o.dimensions );

  if( number !== 0 )
  {

    if( Math.abs( number ) >= o.thousand )
    {

      while( Math.abs( number ) >= o.thousand || !o.metrics[ String( o.metric ) ] )
      {

        if( o.metric + o.divisor > o.metrics.range[ 1 ] ) break;

        number /= o.thousand;
        o.metric += o.divisor;

      }

    }
    else if( Math.abs( number ) < 1 )
    {

      while( Math.abs( number ) < 1 || !o.metrics[ String( o.metric ) ] )
      {

        if( o.metric - o.divisor < o.metrics.range[ 0 ] ) break;

        number *= o.thousand;
        o.metric -= o.divisor;

      }

      if( number / o.thousand > 1 )
      return strMetricFormat( number, { thousand : o.thousand, metric : o.metric, fixed : o.fixed, divisor : o.divisor, metrics : o.metrics, dimensions : o.dimensions } );

    }

  }

  let result = '';

  if( o.metrics[ String( o.metric ) ] )
  {
    result = number.toFixed( o.fixed ) + ' ' + o.metrics[ String( o.metric ) ].symbol;
  }
  else
  {
    result = original.toFixed( o.fixed ) + ' ';
  }

  return result;
}

strMetricFormat.defaults =
{
  divisor : 3,
  thousand : 1000,
  fixed : 1,
  dimensions : 1,
  metric : 0,
  metrics : null,
}

//

/**
 * Short-cut for strMetricFormat() function.
 * Converts number( number ) to specific count of bytes with metric prefix.
 * Example: ( 2048 -> 2.0 kb).
 *
 * @param {string|number} str - Source number to  convert.
 * @param {object} o - conversion options.
 * @param {number} [ o.divisor=3 ] - Sets count of number divisors.
 * @param {number} [ o.thousand=1024 ] - Sets integer power of one thousand.
 * @see {@link wTools.strMetricFormat} Check out main function for more usage options and details.
 * @returns {string} Returns number of bytes with metric prefix as a string.
 *
 * @example
 * //returns "100.0 b"
 * _.strMetricFormatBytes( 100 );
 *
 * @example
 * //returns "4.0 kb"
 * _.strMetricFormatBytes( 4096 );
 *
 * @example
 * //returns "1024.0 Mb"
 * _.strMetricFormatBytes( Math.pow( 2, 30 ) );
 *
 * @function  strMetricFormatBytes
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strMetricFormatBytes( number,o )
{

  o = o || Object.create( null );
  let defaultOptions =
  {
    divisor : 3,
    thousand : 1024,
  };

  _.mapSupplement( o,defaultOptions );

  return _.strMetricFormat( number,o ) + 'b';
}

//

/**
 * Short-cut for strMetricFormat() function.
 * Converts number( number ) to specific count of seconds with metric prefix.
 * Example: ( 1000 (ms) -> 1.000 s).
 *
 * @param {number} str - Source number to  convert.
 * @param {number} [ o.fixed=3 ] - The number of digits to appear after the decimal point, example : [ '58912.001' ].
 * Can`t be changed.
 * @see {@link wTools.strMetricFormat} Check out main function for more usage options and details.
 * @returns {string} Returns number of seconds with metric prefix as a string.
 *
 * @example
 * //returns "1.000 s"
 * _.strTimeFormat( 1000 );
 *
 * @example
 * //returns "10.000 ks"
 * _.strTimeFormat( Math.pow( 10, 7 ) );
 *
 * @example
 * //returns "78.125 s"
 * _.strTimeFormat( Math.pow( 5, 7 ) );
 *
 * @function  strTimeFormat
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strTimeFormat( time )
{
  _.assert( arguments.length === 1 );
  time = _.time.from( time );
  let result = _.strMetricFormat( time*0.001,{ fixed : 3 } ) + 's';
  return result;
}

//

function strCsvFrom( src,o )
{

  let result = '';
  o = o || Object.create( null );

  debugger;

  if( !o.header )
  {

    o.header = [];

    _.look( _.entityValueWithIndex( src,0 ),function( e,k,i )
    {
      o.header.push( k );
    });

  }

  if( o.cellSeparator === undefined ) o.cellSeparator = ',';
  if( o.rowSeparator === undefined ) o.rowSeparator = '\n';
  if( o.substitute === undefined ) o.substitute = '';
  if( o.withHeader === undefined ) o.withHeader = 1;

  //console.log( 'o',o );

  if( o.withHeader )
  {
    _.look( o.header,function( e,k,i ){
      result += e + o.cellSeparator;
    });
    result = result.substr( 0,result.length-o.cellSeparator.length ) + o.rowSeparator;
  }

  _.each( src,function( row )
  {

    let rowString = '';

    _.each( o.header,function( key )
    {

      debugger;
      let element = _.entityWithKeyRecursive( row,key );
      if( element === undefined ) element = '';
      element = String( element );
      if( element.indexOf( o.rowSeparator ) !== -1 )
      element = _.strReplaceAll( element,o.rowSeparator,o.substitute );
      if( element.indexOf( o.cellSeparator ) !== -1 )
      element = _.strReplaceAll( element,o.cellSeparator,o.substitute );

      rowString += element + o.cellSeparator;

    });

    result += rowString.substr( 0,rowString.length-o.cellSeparator.length ) + o.rowSeparator;

  });

  return result;
}

//

function strToDom( xmlStr )
{

  let xmlDoc = null;
  let isIEParser = window.ActiveXObject || "ActiveXObject" in window;

  if( xmlStr === undefined ) return xmlDoc;

  if( window.DOMParser )
  {

    let parser = new window.DOMParser();
    let parsererrorNS = null;

    if( !isIEParser ) {

      try {
        parsererrorNS = parser.parseFromString( "INVALID", "text/xml" ).childNodes[0].namespaceURI;
      }
      catch( err ) {
        parsererrorNS = null;
      }
    }

    try
    {
      xmlDoc = parser.parseFromString( xmlStr, "text/xml" );
      if( parsererrorNS!= null && xmlDoc.getElementsByTagNameNS( parsererrorNS, "parsererror" ).length > 0 )
      {
        throw Error( 'Error parsing XML' );
        xmlDoc = null;
      }
    }
    catch( err )
    {
      throw Error( 'Error parsing XML' );
      xmlDoc = null;
    }
  }
  else
  {
    if( xmlStr.indexOf( "<?" )==0 )
    {
      xmlStr = xmlStr.substr( xmlStr.indexOf( "?>" ) + 2 );
    }
    xmlDoc = new ActiveXObject( "Microsoft.XMLDOM" );
    xmlDoc.async = "false";
    xmlDoc.loadXML( xmlStr );
  }

  return xmlDoc;
}

//

function strToConfig( src,o )
{
  let result = Object.create( null );
  if( !_.strIs( src ) )
  throw _.err( '_.strToConfig :','require string' );

  o = o || Object.create( null );
  if( o.delimeter === undefined ) o.delimeter = ' :';

  let splitted = src.split( '\n' );

  for( let s = 0 ; s < splitted.length ; s++ )
  {

    let row = splitted[ s ];
    let i = row.indexOf( o.delimeter );
    if( i === -1 ) continue;

    let key = row.substr( 0,i ).trim();
    let val = row.substr( i+1 ).trim();

    result[ key ] = val;

  }

  return result;
}

// //
//

// function numberFromStrMaybe( src )
// {
//   _.assert( _.strIs( src ) || _.numberIs( src ) );
//   if( _.numberIs( src ) )
//   return src;
//
//   // if( /^\s*\d+\.{0,1}\d*\s*$/.test( src ) )
//   // return parseFloat( src );
//   // return src
//   // xxx2
//   // let parsed = parseFloat( src );
//
//   let parsed = Number( src );
//   if( !isNaN( parsed ) )
//   return parsed;
//   return src;
// }

// function strToNumberMaybe( src )
// {
//   _.assert( arguments.length === 1 ); /* Dmytro : prevents passing two or more arguments */
//   _.assert( _.strIs( src ) || _.numberIs( src ) );
//
//   if( _.numberIs( src ) )
//   return src;
//
//   // if( /^\s*\d+\.{0,1}\d*\s*$/.test( src ) )
//   // return parseFloat( src );
//   // return src
//   // xxx2
//   // let parsed = parseFloat( src );
//
//   let parsed = Number( src );
//   if( !isNaN( parsed ) )
//   return parsed;
//   return src;
// }

//

/*
qqq : routine strStructureParse requires good coverage and extension | Dmytro : test coverage improved, added test routine `strStructureParseExperiment` with variants of extension

Dmytro : below added new version of routine strStructureParse for new features
*/

// function strStructureParse( o )
// {
//
//   if( _.strIs( o ) )
//   o = { src : o }
//
//   _.routineOptions( strStructureParse, o );
//   _.assert( !!o.keyValDelimeter );
//   _.assert( _.strIs( o.entryDelimeter ) );
//   _.assert( _.strIs( o.src ) );
//   _.assert( arguments.length === 1 );
//   _.assert( _.longHas( [ 'map', 'array', 'string' ], o.defaultStructure ) );
//
//   if( o.arrayElementsDelimeter === null )
//   o.arrayElementsDelimeter = [ ' ', ',' ];
//
//   let src = o.src.trim();
//
//   if( o.parsingArrays )
//   if( _.strIs( _.strInsideOf( src, o.longLeftDelimeter, o.longRightDelimeter ) ) )
//   {
//     let r = strToArrayMaybe( src );
//     if( _.arrayIs( r ) )
//     return r;
//   }
//
//   src = _.strSplit
//   ({
//     src,
//     delimeter : o.keyValDelimeter,
//     stripping : 0,
//     quoting : o.quoting,
//     preservingEmpty : 1,
//     preservingDelimeters : 1,
//     preservingQuoting : o.quoting ? 0 : 1
//   });
//
//   if( src.length === 1 && src[ 0 ] )
//   return src[ 0 ];
//
//   /* */
//
//   let pairs = [];
//   for( let a = 0 ; a < src.length-2 ; a += 2 )
//   {
//     let left = src[ a ];
//     let right = src[ a+2 ].trim();
//
//     _.assert( _.strIs( left ) );
//     _.assert( _.strIs( right ) );
//
//     while( a < src.length-3 )
//     {
//       let cuts = _.strIsolateRightOrAll( right, o.entryDelimeter );
//       if( cuts[ 1 ] === undefined )
//       {
//         right = src[ a+2 ] = src[ a+2 ] + src[ a+3 ] + src[ a+4 ];
//         right = right.trim();
//         // src.splice( a+2, 2 ); // Dmytro : splices new src[ a+2 ] and next iteration deletes previous 2 elements
//         src.splice( a+3, 2 );
//         continue;
//       }
//       right = cuts[ 0 ];
//       src[ a+2 ] = cuts[ 2 ];
//       break;
//     }
//
//     pairs.push( left.trim(), right.trim() );
//   }
//
//   /* */
//
//   _.assert( pairs.length % 2 === 0 );
//   let result = Object.create( null );
//   for( let a = 0 ; a < pairs.length-1 ; a += 2 )
//   {
//     let left = pairs[ a ];
//     let right = pairs[ a+1 ];
//
//     _.assert( _.strIs( left ) );
//     _.assert( _.strIs( right ) );
//
//     if( o.toNumberMaybe )
//     right = _.numberFromStrMaybe( right );
//
//     if( o.parsingArrays )
//     right = strToArrayMaybe( right );
//
//     result[ left ] = right;
//
//   }
//
//   // if( src.length === 1 && src[ 0 ] )
//   // return src[ 0 ];
//   //
//   // debugger;
//
//   if( _.mapKeys( result ).length === 0 )
//   {
//     if( o.defaultStructure === 'map' )
//     return result;
//     else if( o.defaultStructure === 'array' )
//     return [];
//     else if( o.defaultStructure === 'string' )
//     return '';
//   }
//
//   return result;
//
//   /**/
//
//   function strToArrayMaybe( str )
//   {
//     let result = str;
//     if( !_.strIs( result ) )
//     return result;
//     let inside = _.strInsideOf( result, o.longLeftDelimeter, o.longRightDelimeter );
//     if( inside !== false )
//     {
//       let splits = _.strSplit
//       ({
//         src : inside,
//         delimeter : o.arrayElementsDelimeter,
//         stripping : 1,
//         quoting : 1,
//         preservingDelimeters : 0,
//         preservingEmpty : 0,
//       });
//       result = splits;
//       if( o.toNumberMaybe )
//       result = result.map( ( e ) => _.numberFromStrMaybe( e ) );
//     }
//     return result;
//   }
//
// }
//
// strStructureParse.defaults =
// {
//   src : null,
//   keyValDelimeter : ':',
//   entryDelimeter : ' ',
//   arrayElementsDelimeter : null,
//   longLeftDelimeter : '[',
//   longRightDelimeter : ']',
//   quoting : 1,
//   parsingArrays : 0,
//   toNumberMaybe : 1,
//   defaultStructure : 'map', /* map / array / string */
// }

//

function strStructureParse( o )
{

  if( _.strIs( o ) )
  o = { src : o }

  _.routineOptions( strStructureParse, o );
  _.assert( arguments.length === 1 );
  _.assert( !!o.keyValDelimeter );
  _.assert( _.strIs( o.entryDelimeter ) );
  _.assert( _.strIs( o.src ) );
  _.assert( _.longHas( [ 'map', 'array', 'string' ], o.defaultStructure ) );

  if( o.arrayElementsDelimeter === null )
  o.arrayElementsDelimeter = [ ' ', ',' ];

  let src = o.src.trim();

  if( _.strIs( _.strInsideOf( src, o.mapLeftDelimeter, o.mapRightDelimeter ) ) )
  {
    let inside = _.strInsideOf( src, o.mapLeftDelimeter, o.mapRightDelimeter );
    if( new RegExp( '^\\s*\\W*\\w+\\W*\\s*\\' + o.keyValDelimeter +'\\s*\\W*\\w+' ).test( inside ) )
    src = inside;
    else if( /\s*/.test( inside ) )
    return Object.create( null );
  }
  else if( o.parsingArrays )
  {
    if( _.strIs( _.strInsideOf( src, o.longLeftDelimeter, o.longRightDelimeter ) ) )
    {
      let r = strToArrayMaybe( src, o.depth );
      if( _.arrayIs( r ) )
      return r;
    }
  }

  src = _.strSplit
  ({
    src,
    delimeter : o.keyValDelimeter,
    stripping : 0,
    quoting : o.quoting,
    preservingEmpty : 1,
    preservingDelimeters : 1,
    preservingQuoting : 0
  });

  if( src.length === 1 && src[ 0 ] )
  return src[ 0 ];

  strSplitsParenthesesBalanceJoin( src );

  /* */

  let pairs = [];
  for( let a = 0 ; a < src.length-2 ; a += 2 )
  {
    let left = src[ a ];
    let right = src[ a+2 ].trim();

    _.assert( _.strIs( left ) );
    _.assert( _.strIs( right ) );

    while( a < src.length-3 )
    {
      let cuts = _.strIsolateRightOrAll( right, o.entryDelimeter );
      if( cuts[ 1 ] === undefined )
      {
        right = src[ a+2 ] = src[ a+2 ] + src[ a+3 ] + src[ a+4 ];
        right = right.trim();
        src.splice( a+3, 2 );
        continue;
      }
      right = cuts[ 0 ];
      src[ a+2 ] = cuts[ 2 ];
      break;
    }

    pairs.push( left.trim(), right.trim() );
  }

  /* */

  _.assert( pairs.length % 2 === 0 );
  let result = Object.create( null );
  for( let a = 0 ; a < pairs.length-1 ; a += 2 )
  {
    let left = pairs[ a ];
    let right = pairs[ a+1 ];

    _.assert( _.strIs( left ) );
    _.assert( _.strIs( right ) );

    if( o.toNumberMaybe )
    right = _.numberFromStrMaybe( right );

    if( o.parsingArrays )
    right = strToArrayMaybe( right, o.depth );


    if( o.depth > 0 )
    {
      let options = _.mapExtend( null, o );
      options.depth = o.depth - 1;
      if( _.strIs( right ) )
      {
        options.src = right;
        right = _.strStructureParse( options );
      }
    }

    if( o.onTerminal && _.strIs( right ) )
    right = o.onTerminal( right );

    if( o.severalValues )
    {
      result[ left ] = _.scalarAppendOnce( result[ left ], right );
    }
    else
    {
      result[ left ] = right;
    }

  }

  if( _.mapKeys( result ).length === 0 )
  {
    if( o.defaultStructure === 'map' )
    return result;
    else if( o.defaultStructure === 'array' )
    return [];
    else if( o.defaultStructure === 'string' )
    return '';
  }

  return result;

  /**/

  function strToArrayMaybe( str, depth )
  {
    let result = str;
    if( !_.strIs( result ) )
    return result;
    let inside = _.strInsideOf( result, o.longLeftDelimeter, o.longRightDelimeter );
    if( inside !== false )
    {
      let splits = _.strSplit
      ({
        src : inside,
        delimeter : o.arrayElementsDelimeter,
        stripping : 1,
        quoting : o.quoting,
        preservingDelimeters : 0,
        preservingEmpty : 0,
        preservingQuoting : 0,
      });
      result = splits;

      if( o.toNumberMaybe )
      result = result.map( ( e ) => _.numberFromStrMaybe( e ) );
      if( depth > 0 )
      {
        debugger;
        depth--;

        strSplitsParenthesesBalanceJoin( result );
        let options = _.mapExtend( null, o );
        options.depth = depth;
        for( let i = 0; i < result.length; i++ )
        {
          if( _.strIs( result[ i ] ) )
          {
            options.src = result[ i ];
            result[ i ] = _.strStructureParse( options );
          }
        }
      }
      if( o.onTerminal )
      result = result.map( ( e ) => o.onTerminal( e ) )
    }
    return result;
  }

  /* */

  function strSplitsParenthesesBalanceJoin( splits )
  {
    let stack = [];
    let postfixes = [ _.regexpFrom( o.longRightDelimeter ), _.regexpFrom( o.mapRightDelimeter ) ];
    let map =
    {
      [ o.longLeftDelimeter ] : o.longRightDelimeter,
      [ o.mapLeftDelimeter ] : o.mapRightDelimeter
    };

    for( let i = 0; i < splits.length; i++ )
    {
      if( !_.strIs( splits[ i ] ) )
      {
        continue;
      }
      if( splits[ i ] in map )
      {
        stack.push( i );
      }
      else if( _.regexpsTestAny( postfixes, splits[ i ] ) )
      {
        if( stack.length === 0 )
        continue;

        let start = -1;
        let end = i;

        for( let k = stack.length - 1 ; k >= 0 ; k-- )
        if( map[ splits[ stack[ k ] ] ] === splits[ end ] )
        {
          start = stack[ k ];
          stack.splice( k, stack.length );
          break;
        }

        if( start === -1 )
        continue;

        let length = end - start;

        splits[ start ] = splits.splice( start, length + 1, null ).join( o.entryDelimeter );
        i -= length;
      }
    }
  }

}

strStructureParse.defaults =
{
  src : null,
  keyValDelimeter : ':',
  entryDelimeter : ' ',
  arrayElementsDelimeter : null,
  mapLeftDelimeter : '{',
  mapRightDelimeter : '}',
  longLeftDelimeter : '[',
  longRightDelimeter : ']',
  quoting : 1,
  parsingArrays : 0,
  severalValues : 0,
  depth : 0,
  onTerminal : null,
  toNumberMaybe : 1,
  defaultStructure : 'map', /* map / array / string */
}

// function strStructureParse( o )
// {
//
//   if( _.strIs( o ) )
//   o = { src : o }
//
//   _.routineOptions( strStructureParse, o );
//   _.assert( !!o.keyValDelimeter );
//   _.assert( _.strIs( o.entryDelimeter ) );
//   _.assert( _.strIs( o.src ) );
//   _.assert( arguments.length === 1 );
//   _.assert( _.longHas( [ 'map', 'array', 'string' ], o.defaultStructure ) );
//
//   if( o.arrayElementsDelimeter === null )
//   o.arrayElementsDelimeter = [ ' ', ',' ];
//
//   let src = o.src.trim();
//
//   if( o.parsingArrays )
//   if( _.strIs( _.strInsideOf( src, o.longLeftDelimeter, o.longRightDelimeter ) ) )
//   {
//     let r = strToArrayMaybe( src );
//     if( _.arrayIs( r ) )
//     return r;
//   }
//
//   src = _.strSplit
//   ({
//     src,
//     delimeter : o.keyValDelimeter,
//     stripping : 1,
//     quoting : o.quoting,
//     preservingEmpty : 1,
//     preservingDelimeters : 0,
//     preservingQuoting : o.quoting ? 0 : 1
//   });
//
//   /* */
//
//   // let pairs = [];
//   // for( let a = 0 ; a < src.length ; a++ )
//   // {
//   //   let left = src[ a ];
//   //   let right = src[ a+1 ];
//   //
//   //   _.assert( _.strIs( left ) );
//   //   _.assert( _.strIs( right ) );
//   //
//   //   debugger;
//   //   while( a < src.length - 1 )
//   //   {
//   //     let cuts = _.strIsolateRightOrAll( right, o.entryDelimeter );
//   //     if( cuts[ 1 ] === undefined )
//   //     {
//   //       right = src[ a+1 ] = src[ a ] + src[ a+1 ] + src[ a+1 ];
//   //       src.splice( a+1, 1 );
//   //       continue;
//   //     }
//   //     right = cuts[ 0 ];
//   //     src[ a ] = cuts[ 2 ];
//   //     break;
//   //   }
//   //
//   // }
//
//   /* */
//
//   let result = Object.create( null );
//   for( let a = 1 ; a < src.length ; a++ )
//   {
//     let left = src[ a-1 ];
//     let right = src[ a+0 ];
//
//     _.assert( _.strIs( left ) );
//     _.assert( _.strIs( right ) );
//
//     // debugger;
//     while( a < src.length - 1 )
//     {
//       let cuts = _.strIsolateRightOrAll( right, o.entryDelimeter );
//       // if( cuts[ 1 ] === undefined )
//       // {
//       //   right = src[ a ] = src[ a ] + src[ a+1 ];
//       //   src.splice( a+1, 1 );
//       //   continue;
//       // }
//       right = cuts[ 0 ];
//       src[ a ] = cuts[ 2 ];
//       break;
//     }
//
//     result[ left ] = right;
//
//     if( o.toNumberMaybe )
//     result[ left ] = _.numberFromStrMaybe( result[ left ] );
//
//     if( o.parsingArrays )
//     result[ left ] = strToArrayMaybe( result[ left ] );
//
//   }
//
//   if( src.length === 1 && src[ 0 ] )
//   return src[ 0 ];
//
//   if( _.mapKeys( result ).length === 0 )
//   {
//     if( o.defaultStructure === 'map' )
//     return result;
//     else if( o.defaultStructure === 'array' )
//     return [];
//     else if( o.defaultStructure === 'string' )
//     return '';
//   }
//
//   return result;
//
//   /**/
//
//   function strToArrayMaybe( str )
//   {
//     let result = str;
//     if( !_.strIs( result ) )
//     return result;
//     let inside = _.strInsideOf( result, o.longLeftDelimeter, o.longRightDelimeter );
//     if( inside !== false )
//     {
//       let splits = _.strSplit
//       ({
//         src : inside,
//         delimeter : o.arrayElementsDelimeter,
//         stripping : 1,
//         quoting : 1,
//         preservingDelimeters : 0,
//         preservingEmpty : 0,
//       });
//       result = splits;
//       if( o.toNumberMaybe )
//       result = result.map( ( e ) => _.numberFromStrMaybe( e ) );
//     }
//     return result;
//   }
//
// }
//
// strStructureParse.defaults =
// {
//   src : null,
//   keyValDelimeter : ':',
//   entryDelimeter : ' ',
//   arrayElementsDelimeter : null,
//   longLeftDelimeter : '[',
//   longRightDelimeter : ']',
//   quoting : 1,
//   parsingArrays : 0,
//   toNumberMaybe : 1,
//   defaultStructure : 'map', /* map / array / string */
// }

//

/*
qqq : routine strWebQueryParse requires good coverage and extension | Dmytro : coverage added, extension of routine and coverage after routine strStructureParse
*/

function strWebQueryParse( o )
{

  if( _.strIs( o ) )
  o = { src : o }

  _.routineOptions( strWebQueryParse, o );
  _.assert( arguments.length === 1 );

  if( o.keyValDelimeter === null )
  o.keyValDelimeter = [ ':', '=' ];

  return _.strStructureParse( o );
}

var defaults = strWebQueryParse.defaults = Object.create( strStructureParse.defaults );

defaults.defaultStructure = 'map';
defaults.parsingArrays = 0;
defaults.keyValDelimeter = null; /* [ ':', '=' ] */
defaults.entryDelimeter = '&';
defaults.toNumberMaybe = 1;
/* toNumberMaybe must be on by default */

// Dmytro : missed, produces bug if value in key-value pairs starts with number literal or need improve condition in routine numberFromStrMaybe
// qqq

//

/*
qqq : routine strWebQueryStr requires good coverage | Dmytro : covered
*/

function strWebQueryStr( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' ); // Dmytro : missed

  if( _.strIs( o ) )
  return o;

  _.routineOptions( strWebQueryStr, o ); // Dmytro : missed

  let result = _.mapToStr( o );

  return result;
}

var defaults = strWebQueryStr.defaults = Object.create( null );
defaults.src = null; // Dmytro : missed
defaults.keyValDelimeter = ':';
defaults.entryDelimeter = '&';

//

function strRequestParse( o )
{

  if( _.strIs( o ) )
  o = { src : o };

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strIs( o.src ) );
  o = _.routineOptions( strRequestParse, o );

  if( _.boolLike( o.quoting ) && o.quoting )
  o.quoting = [ '"', '`', '\'' ];
  if( o.quoting )
  o.quoting = _.strQuotePairsNormalize( o.quoting );

  let result = Object.create( null );
  result.subject = '';
  result.map = Object.create( null );
  result.subjects = [];
  result.maps = [];
  result.keyValDelimeter = o.keyValDelimeter;
  result.commandsDelimeter = o.commandsDelimeter;
  result.original = o.src;

  o.src = o.src.trim();

  if( !o.src )
  return result;

  if( o.unquoting && o.quoting )
  {
    // let isolated = _.strIsolateInside( o.src, o.quoting );
    // if( isolated[ 0 ] === '' && isolated[ 4 ] === '' )
    // o.src = isolated[ 2 ];
    o.src = _.strUnquote( o.src, o.quoting );
  }

  /* should be strSplit, not strIsolateLeftOrAll because of quoting */

  let commands = _.strSplit
  ({
    src : o.src,
    delimeter : o.commandsDelimeter,
    stripping : 1,
    quoting : o.quoting,
    preservingDelimeters : 0,
    preservingEmpty : 0,
  });

  /* */

  for( let c = 0 ; c < commands.length ; c++ )
  {

    /* xxx : imlement parsing with template

      b ?** ':' ** e
      b ?** ':' ?** ':' ** e
      b ?*+ s+ ??*+ ':' *+ e
      b ( ?*+ )? <&( s+ )&> ( ??*+ ':' *+ )? e

    b subject:?** s+ map:** e
    // 'c:/dir1 debug:0' -> subject : 'c:/dir1', debug:0

    // test.identical( _.strCount( op.output, /program.end(.|\n|\r)*timeout1/mg ), 1 );
    test.identical( _.strCount( op.output, `'program.end'**'timeout1'` ), 1 );

    */

    let mapEntries = [ commands[ c ], null, '' ];

    // if( o.keyValDelimeter )
    // mapEntries = _.strSplit
    // ({
    //   src : commands[ c ],
    //   delimeter : o.keyValDelimeter,
    //   stripping : 1,
    //   quoting : o.quoting,
    //   preservingDelimeters : 1,
    //   preservingEmpty : 0,
    // });

    // debugger;
    if( o.keyValDelimeter )
    mapEntries = _.strIsolateLeftOrAll
    ({
      src : commands[ c ],
      delimeter : o.keyValDelimeter,
      quote : o.quoting,
    })

    // let subjectAndKey = _.strIsolateRightOrAll
    // ({
    //   src : mapEntries[ 0 ].trim(),
    //   delimeter : ' ',
    //   quote : o.quoting,
    // })
    // let subject = subjectAndKey[ 0 ];
    // mapEntries[ 0 ] = subjectAndKey[ 2 ];


    let subject;
    let map;
    // let subject, map;
    // if( mapEntries.length === 1 )
    if( !mapEntries[ 1 ] )
    {
      subject = mapEntries[ 0 ];
      map = Object.create( null );
    }
    else
    {
      // debugger;
      // let subjectAndKey = _.strIsolateRightOrAll( mapEntries[ 0 ].trim(), ' ' );
      // subject = subjectAndKey[ 0 ];
      // mapEntries[ 0 ] = subjectAndKey[ 2 ];

      let subjectAndKey = _.strIsolateRightOrAll
      ({
        src : mapEntries[ 0 ].trim(),
        delimeter : ' ',
        quote : o.quoting,
      })
      subject = subjectAndKey[ 0 ];
      mapEntries[ 0 ] = subjectAndKey[ 2 ];

      map = _.strStructureParse
      ({
        src : mapEntries.join( '' ),
        keyValDelimeter : o.keyValDelimeter,
        parsingArrays : o.parsingArrays,
        quoting : o.quoting,
        severalValues : o.severalValues,
      });

    }

    // let mapEntries = [ commands[ c ] ];
    // if( o.keyValDelimeter )
    // mapEntries = _.strSplit
    // ({
    //   src : commands[ c ],
    //   delimeter : o.keyValDelimeter,
    //   stripping : 1,
    //   quoting : o.quoting,
    //   preservingDelimeters : 1,
    //   preservingEmpty : 0,
    // });
    //
    // let subject, map;
    // if( mapEntries.length === 1 )
    // {
    //   subject = mapEntries[ 0 ];
    //   map = Object.create( null );
    // }
    // else
    // {
    //   let subjectAndKey = _.strIsolateRightOrAll( mapEntries[ 0 ], ' ' );
    //   subject = subjectAndKey[ 0 ];
    //   mapEntries[ 0 ] = subjectAndKey[ 2 ];
    //
    //   map = _.strStructureParse
    //   ({
    //     src : mapEntries.join( '' ),
    //     keyValDelimeter : o.keyValDelimeter,
    //     parsingArrays : o.parsingArrays,
    //     quoting : o.quoting,
    //   });
    //
    // }

    result.subjects.push( subject );
    result.maps.push( map );
  }

  if( result.subjects.length )
  result.subject = result.subjects[ 0 ];
  if( result.maps.length )
  result.map = result.maps[ 0 ];

  return result;
}

var defaults = strRequestParse.defaults = Object.create( null );
defaults.keyValDelimeter = ':';
defaults.commandsDelimeter = ';';
defaults.quoting = 1;
defaults.unquoting = 1;
defaults.parsingArrays = 1;
defaults.severalValues = 0;
defaults.src = null;
defaults.severalValues = 0;

//

/**
 * Routine strRequestStr() rebuilds original command string from parsed structure {-o-}.
 *
 * @param { ObjectLike } o - Object, which represents parsed command:
 * @param { String } o.subject - First command in sequence of commands.
 * @param { Map } o.map - Map options for first command {-o.subject-}.
 * @param { Long } o.subjects - An array of commands.
 * @param { Map } o.maps - Map options for commands.
 * @param { String } o.keyValDelimeter - Delimeter for key and vals in map options.
 * @param { String } o.commandsDelimeter - Delimeter for sequence of commands, each
 * pair of subject-map will be separated by it.
 * @param { String } o.original - Original command string, if this option is defined,
 * then routine returns {-o.original-}.
 * Note. Routine try to make command by using options {-o.subjects-} and {-o.subject-}.
 * Firstly, routine checks {-o.subjects-} and appends options for each command. If
 * {-o.subjects-} not exists, then routine check {-o.subject-} and append options from
 * {-o.map-}. Otherwise, empty string returns.
 *
 * @example
 * _.strRequestStr( { original : '.build abc debug:0 ; .set v:10' } );
 * //returns '.build abc debug:0 ; .set v:10'
 *
 * @example
 * _.strRequestStr( { original : '.build abc debug:0 ; .set v:10', subjects : [ '.build some', '.set' ], maps : [ { debug : 1 }, { v : 1 } ] } );
 * //returns '.build abc debug:0 ; .set v:10'
 *
 * @example
 * _.strRequestStr( { subjects : [ '.build some', '.set' ], maps : [ { debug : 1 }, { v : 1 } ] } );
 * //returns '.build some debug:1 ; .set v:1'
 *
 * @example
 * _.strRequestStr( { subjects : [ '.build some', '.set' ], maps : [ { debug : 1 }, { v : 1 } ], subject : '.run /home/user', map : { v : 5 } } );
 * //returns '.build some debug:1 ; .set v:1'
 *
 * @example
 * _.strRequestStr( { subject : '.run /home/user', map : { v : 5 } } );
 * //returns '.run /home/user v:5'
 *
 * @example
 * _.strRequestStr( { subjects : [ '.run /home/user' ], map : { v : 5 } } );
 * //returns '.run /home/user'
 *
 * @example
 * _.strRequestStr( { map : { v : 5 }, maps : [ { v : 5 }, { routine : 'strIs' } ] } );
 * //returns ''
 *
 * @returns { String } - Returns original command builded from parsed structure.
 * @function  strRequestStr
 * @throws { Error } If arguments.length is less or more then one.
 * @throws { Error } If {-o.original-} exists and it is not a String.
 * @throws { Error } If {-o.subject-} is not a String.
 * @throws { Error } If {-o.map-} is not map like.
 * @throws { Error } If elements of {-o.subjects-} is not a Strings.
 * @throws { Error } If elements of {-o.maps-} is not map like.
 * @namespace Tools
 *
 */

function strRequestStr( o )
{

  _.assert( arguments.length === 1 );
  o = _.routineOptions( strRequestStr, arguments );

  if( o.original )
  {
    _.assert( _.strIs( o.original ) );
    return o.original;
  }

  let result = '';

  if( o.subjects.length > 0 )
  {

    for( let i = 0 ; i < o.subjects.length ; i++ )
    {
      if( o.subjects[ i ] !== undefined )
      {
        _.assert( _.strIs( o.subjects[ i ] ) );
        if( o.subjects[ i ] !== '' )
        result += o.subjects[ i ] + ' ';
      }
      if( o.maps[ i ] !== undefined )
      {
        _.assert( _.mapIs( o.maps[ i ] ) );
        let map = o.maps[ i ];
        for( let k in map )
        {
          result += k + o.keyValDelimeter;
          if( _.longIs( map[ k ] ) )
          result += '[' + map[ k ] + '] ';
          else
          result += map[ k ] + ' ';
        }
      }
      if( o.subjects[ i + 1 ] !== undefined )
      result += o.commandsDelimeter + ' ';
    }

  }
  else if( o.subject )
  {

    if( o.subject )
    {
      _.assert( _.strIs( o.subject ) );
      result += o.subject + ' ';
    }
    if( o.map )
    {
      for( let k in o.map )
      {
        _.assert( _.mapIs( o.map ) );
        result += k + o.keyValDelimeter;
        if( _.longIs( o.map[ k ] ) )
        result += '[' + o.map[ k ] + '] ';
        else
        result += o.map[ k ] + ' ';
      }
    }

  }
  // _.assert( 0, 'not implemented' );
  /* qqq : implement, document, cover please | Dmytro : implemented, covered, documented */

  return result.trim();
}

var defaults = strRequestStr.defaults = Object.create( null );

defaults.subject = null;
defaults.map = null;
defaults.subjects = null;
defaults.maps = null;
defaults.keyValDelimeter = strRequestParse.defaults.keyValDelimeter;
defaults.commandsDelimeter = strRequestParse.defaults.commandsDelimeter;
defaults.original = null;

//

function strCommandParse( o )
{
  if( _.strIs( o ) )
  o = { src : o }
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strIs( o.src ) );
  o = _.routineOptions( strCommandParse, o );

  let tokens = _.strSplit({ src : o.commandFormat, delimeter : [ '?', 'subject', 'options' ], preservingEmpty : 0 });

  _.each( tokens, ( token ) => _.assert( _.longHas( [ '?', 'subject', 'options' ], token ), 'Unknown token:', token ) );

  let subjectToken = _.strHas( o.commandFormat, 'subject' );
  let subjectTokenMaybe = _.strHas( o.commandFormat, 'subject?' );
  let optionsToken = _.strHas( o.commandFormat, 'options' );
  let optionsTokenMaybe = _.strHas( o.commandFormat, 'options?' );

  let result = Object.create( null );

  result.subject = '';
  result.map = Object.create( null );
  result.subjects = [];
  result.maps = [];
  result.keyValDelimeter = o.keyValDelimeter;
  result.commandsDelimeter = o.commandsDelimeter;

  if( !o.src )
  return result;

  /* */

  let mapEntries = [ o.src ];
  if( o.keyValDelimeter )
  mapEntries = _.strSplit
  ({
    src : o.src,
    delimeter : o.keyValDelimeter,
    stripping : 1,
    quoting : 1,
    preservingDelimeters : 1,
    preservingEmpty : 0,
  });

  let subject = '';
  let map = Object.create( null );

  if( mapEntries.length === 1 )
  {
    if( subjectToken )
    subject = mapEntries[ 0 ];
  }
  else
  {
    if( subjectToken )
    {
      let subjectAndKey;

      if( !optionsToken )
      subject = _.strStrip( o.src );
      else if( _.strBegins( o.commandFormat, 'subject' ) )
      {
        subjectAndKey = _.strIsolateRightOrAll( mapEntries[ 0 ], ' ' );
        subject = subjectAndKey[ 0 ];
        mapEntries[ 0 ] = subjectAndKey[ 2 ];

        if( !subject.length && !subjectTokenMaybe )
        {
          let src = mapEntries.splice( 0, 3 ).join( '' );
          subjectAndKey = _.strIsolateLeftOrAll( src, ' ' );
          subject = subjectAndKey[ 0 ];
          mapEntries.unshift( subjectAndKey[ 2 ] )
        }
      }
      else
      {
        subjectAndKey = _.strIsolateLeftOrAll( mapEntries[ mapEntries.length - 1 ], ' ' );
        subject = subjectAndKey[ 2 ];
        mapEntries[ mapEntries.length - 1 ] = subjectAndKey[ 0 ];

        if( !subject.length && !subjectTokenMaybe )
        {
          let src = mapEntries.splice( -3 ).join( '' );
          subjectAndKey = _.strIsolateLeftOrAll( src, ' ' );
          subject = subjectAndKey[ 2 ];
          mapEntries.push( subjectAndKey[ 0 ] )
        }

      }
    }

    if( optionsToken )
    {
      map = _.strStructureParse
      ({
        src : mapEntries.join( '' ),
        keyValDelimeter : o.keyValDelimeter,
        parsingArrays : o.parsingArrays,
        quoting : o.quoting
      });
    }
  }

  if( subjectToken )
  _.sure( subjectTokenMaybe || subject.length, 'No subject found in string:', o.src )

  if( optionsToken )
  _.sure( optionsTokenMaybe || _.mapKeys( map ).length, 'No options found in string:', o.src )

  result.subjects.push( subject );
  result.maps.push( map );

  result.subject = subject;
  result.map = map;

  return result;
}

var defaults = strCommandParse.defaults = Object.create( null );
defaults.keyValDelimeter = ':';
defaults.quoting = 1;
defaults.parsingArrays = 1;
defaults.src = null;
defaults.commandFormat = 'subject? options?';

//

function strCommandsParse( o )
{
  if( _.strIs( o ) )
  o = { src : o }
  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.strIs( o.src ) );
  o = _.routineOptions( strCommandsParse, o );

  let result = Object.create( null );

  result.subject = '';
  result.map = Object.create( null );
  result.subjects = [];
  result.maps = [];
  result.keyValDelimeter = o.keyValDelimeter;
  result.commandsDelimeter = o.commandsDelimeter;

  if( !o.src )
  return result;

  /* should be strSplit, but not strIsolateLeftOrAll because of quoting */

  let commands = _.strSplit
  ({
    src : o.src,
    delimeter : o.commandsDelimeter,
    stripping : 1,
    quoting : 1,
    preservingDelimeters : 0,
    preservingEmpty : 0,
  });

  let o2 = _.mapOnly( o, strCommandParse.defaults );

  for( let c = 0 ; c < commands.length ; c++ )
  {
    o2.src = commands[ c ];
    let parsedCommand = _.strCommandParse( o2 );
    _.arrayAppendArray( result.subjects, parsedCommand.subjects );
    _.arrayAppendArray( result.maps, parsedCommand.maps );
  }

  result.subject = result.subjects[ 0 ];
  result.map = result.maps[ 0 ];

  return result;
}

var defaults = strCommandsParse.defaults = Object.create( strCommandParse.defaults );
defaults.commandsDelimeter = ';';

//

function strJoinMap( o )
{

  _.routineOptions( strJoinMap, o );
  _.assert( _.strIs( o.keyValDelimeter ) );
  _.assert( _.strIs( o.entryDelimeter ) );
  _.assert( _.objectIs( o.src ) );
  _.assert( arguments.length === 1 );

  let result = '';
  let c = 0;
  for( let s in o.src )
  {
    if( c > 0 )
    result += o.entryDelimeter;
    result += s + o.keyValDelimeter + o.src[ s ];
    c += 1;
  }

  return result;
}

strJoinMap.defaults =
{
  src : null,
  keyValDelimeter : ':',
  entryDelimeter : ' ',
}

// --
// strTable
// --

function strTable( o )
{
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !_.objectIs( o ) )
  o = { data : o }
  _.routineOptions( strTable,o );
  _.assert( _.longIs( o.data ) );

  if( typeof module !== 'undefined' && module !== null )
  {
    if( !_.cliTable  )
    try
    {
      _.cliTable = require( 'cli-table2' );
    }
    catch( err )
    {
    }
  }

  if( _.cliTable == undefined )
  {
    if( !o.silent )
    throw _.err( 'version of strTable without support of cli-table2 is not implemented' );
    else
    return;
  }

  /* */

  function makeWidth( propertyName, def, len )
  {
    let property = o[ propertyName ];
    debugger;
    let _property = _.longFill( [], def, len );
    // let _property = _.longFillTimes( [], len, def );
    if( property )
    {
      _.assert( _.mapIs( property ) || _.longIs( property ) , 'routine expects colWidths/rowWidths property as Object or Array-Like' );
      for( let k in property )
      {
        k = _.numberFrom( k );
        if( k < len )
        {
          _.assert( _.numberIs( property[ k ] ) );
          _property[ k ] = property[ k ];
        }
      }
    }
    o[ propertyName ] = _property;
  }

  //

  let isArrayOfArrays = true;
  let maxLen = 0;
  for( let i = 0; i < o.data.length; i++ )
  {
    if( !_.longIs( o.data[ i ] ) )
    {
      isArrayOfArrays = false;
      break;
    }

    maxLen = Math.max( maxLen, o.data[ i ].length );
  }

  let onCellGet = strTable.onCellGet;
  o.onCellGet = o.onCellGet || isArrayOfArrays ? onCellGet.ofArrayOfArray :  onCellGet.ofFlatArray ;
  o.onCellAfter = o.onCellAfter || strTable.onCellAfter;

  if( isArrayOfArrays )
  {
    o.rowsNumber = o.data.length;
    o.colsNumber = maxLen;
  }
  else
  {
    _.assert( _.numberIs( o.rowsNumber ) && _.numberIs( o.colsNumber ) );
  }

  //

  makeWidth( 'colWidths', o.colWidth, o.colsNumber );
  makeWidth( 'colAligns', o.colAlign, o.colsNumber );
  makeWidth( 'rowWidths', o.rowWidth, o.rowsNumber );
  makeWidth( 'rowAligns', o.rowAlign, o.rowsNumber );

  let tableOptions =
  {
    head : o.head,
    colWidths : o.colWidths,
    rowWidths : o.rowWidths,
    colAligns : o.colAligns,
    rowAligns : o.rowAligns,
    style :
    {
      compact : !!o.compact,
      'padding-left' : o.paddingLeft,
      'padding-right' : o.paddingRight,
    }
  }

  let table = new _.cliTable( tableOptions );

  //

  for( let y = 0; y < o.rowsNumber; y++ )
  {
    let row = [];
    table.push( row );

    for( let x = 0; x < o.colsNumber; x++ )
    {
      let index2d = [ y, x ];
      let cellData = o.onCellGet( o.data, index2d, o );
      let cellStr;

      if( cellData === undefined )
      cellData = cellStr = '';
      else
      cellStr = _.toStr( cellData, { wrap : 0, stringWrapper : '' } );

      cellStr = o.onCellAfter( cellStr, index2d, o );
      row.push( cellStr );
    }
  }

  return table.toString();
}

strTable.defaults =
{
  data : null,
  rowsNumber : null,
  colsNumber : null,

  head : null,

  rowWidth : 5,
  rowWidths : null,
  rowAlign : 'center',
  rowAligns : null,

  colWidth : 5,
  colWidths : null,
  colAlign : 'center',
  colAligns : null,

  compact : 1,
  silent : 1,

  paddingLeft : 0,
  paddingRight : 0,


  onCellGet : null,
  onCellAfter : null,
}

strTable.onCellGet =
{
  ofFlatArray : ( data, index2d, o  ) => data[ index2d[ 0 ] * o.colsNumber + index2d[ 1 ] ],
  ofArrayOfArray : ( data, index2d, o  ) => data[ index2d[ 0 ] ][ index2d[ 1 ] ]
}

strTable.onCellAfter = ( cellStr, index2d, o ) => cellStr

//

function strsSort( srcs )
{

  _.assert( _.strsAreAll( srcs ) );

  let result = srcs.sort( function( a, b )
  {
    if( a < b )
    return -1;
    if( a > b )
    return +1;
    return 0;
  });

  return result;
}

//

function strSimilarity( src1,src2 )
{
  _.assert( _.strIs( src1 ) );
  _.assert( _.strIs( src2 ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  debugger;

  let spectres = [ _.strLattersSpectre( src1 ),_.strLattersSpectre( src2 ) ];
  let result = _.strLattersSpectresSimilarity( spectres[ 0 ],spectres[ 1 ] );

  return result;
}

//

function strLattersSpectre( src )
{
  let total = 0;
  let result = new U32x( 257 );

  _.assert( arguments.length === 1 );

  for( let s = 0 ; s < src.length ; s++ )
  {
    let c = src.charCodeAt( s );
    result[ c & 0xff ] += 1;
    total += 1;
    c = c >> 8;
    if( c === 0 )
    continue;
    result[ c & 0xff ] += 1;
    total += 1;
    if( c === 0 )
    continue;
    result[ c & 0xff ] += 1;
    total += 1;
    if( c === 0 )
    continue;
    result[ c & 0xff ] += 1;
    total += 1;
  }

  result[ 256 ] = total;

  return result;
}

//

function strLattersSpectresSimilarity( src1, src2 )
{
  let result = 0;
  let minl = Math.min( src1[ 256 ], src2[ 256 ] );
  let maxl = Math.max( src1[ 256 ], src2[ 256 ] );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( src1.length === src2.length );

  for( let s = 0 ; s < src1.length-1 ; s++ )
  {
    result += Math.abs( src1[ s ] - src2[ s ] );
  }

  result = ( minl / maxl ) - ( 0.5 * result / maxl );

  if( result > 1 )
  debugger;

  result = _.numberClamp( result, [ 0,1 ] );

  return result;
}

//
//
// function lattersSpectreComparison( src1,src2 )
// {
//
//   let same = 0;
//
//   if( src1.length === 0 && src2.length === 0 ) return 1;
//
//   for( let l in src1 )
//   {
//     if( l === 'length' ) continue;
//     if( src2[ l ] ) same += Math.min( src1[ l ],src2[ l ] );
//   }
//
//   return same / Math.max( src1.length,src2.length );
// }

// --
// declare
// --

let Extend =
{

  // strDecamelize,
  strCamelize,
  strToTitle,

  strFilenameFor,
  strVarNameFor,
  strHtmlEscape,

  strSearch,
  strFindAll,

  TokensSyntax,
  tokensSyntaxFrom,

  _strReplaceMapPrepare,
  strReplaceAll, /* qqq : document me | Dmytro : extended documentation */
  strTokenizeJs,
  strTokenizeCpp,

  strSubs,

  strSorterParse,
  jsonParse,

  // format

  strToBytes,
  strMetricFormat,
  strMetricFormatBytes,

  strTimeFormat,

  strCsvFrom, /* experimental */
  strToDom, /* experimental */ // xxx : move it out
  strToConfig, /* experimental */

  // numberFromStrMaybe,
  strStructureParse, /* qqq : cover it by tests | Dmytro : covered */
  strWebQueryParse, /* qqq : cover it by tests | Dmytro : covered */
  strWebQueryStr,
  strRequestParse,
  strRequestStr,
  strCommandParse,
  strCommandsParse,

  strJoinMap, /* qqq : cover it by tests | Dmytro : covered */

  strTable,
  strsSort,

  strSimilarity, /* experimental */
  strLattersSpectre, /* experimental */
  strLattersSpectresSimilarity,
  // lattersSpectreComparison, /* experimental */

}

_.mapExtend( Self, Extend );

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
