import fs from 'node:fs/promises';
/**
 * Check if a number lies in a range
 * @param {number} num
 * @param {string[]} ranges 
 */
function checkInRanges(num, ranges) {
    let min = 0;
    let max = 0;
    let fallsInRange = [];
    for(let r of ranges) {
        min = + r.split("-")[0];
        max = + r.split("-")[1];
        if(num >= min && num <= max) return true;
    }
    return false;
}


var inputData = [];

try {
  const data = await fs.readFile('input.txt', { encoding: 'utf8' });
  inputData = data.split("\n");
} catch (err) {
  console.error(err);
}

/**
 * @type {number}
 */
var separator = inputData.indexOf('');

let ranges = inputData.slice(0,separator);
let ingredientIds = inputData.slice(separator + 1);
let freshIngredients = 0;

for(let ing of ingredientIds) {
    if(checkInRanges(+ ing,ranges)) freshIngredients++;
}
console.log(freshIngredients)