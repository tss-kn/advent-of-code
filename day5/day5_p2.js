import fs from 'node:fs/promises';
/**
 * Check if a number lies in a range
 * @param {number} num
 */
function getRanges(ranges) {
  // Step 1: parse into numeric pairs
  const parsed = ranges
    .map(r => r.split("-").map(Number))
    .sort((a, b) => a[0] - b[0]); // Step 2: sort by start

  const merged = [];
  let [curMin, curMax] = parsed[0];
  let total = 0;

  // Step 3: walk through and merge
  for (let i = 1; i < parsed.length; i++) {
    const [min, max] = parsed[i];

    if (min <= curMax) {
      // Overlap → extend the current range
      curMax = Math.max(curMax, max);
    } else {
      // No overlap → push the previous range
      merged.push([curMin, curMax]);
      [curMin, curMax] = [min, max];
    }
  }

  // Push the final range
  merged.push([curMin, curMax]);

  for(let r of merged) {
    total += ((r[1] + 1) - r[0])
  }

  return total;
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
// let ingredientIds = inputData.slice(separator + 1);
// let freshIngredients = 0;

console.log(getRanges(ranges))