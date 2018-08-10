import 'package:closet_app/item.dart';
import 'package:closet_app/outfit.dart';

Map<String, String> sqlMapItem = {
  'owned':
  '''
    SELECT * FROM ${Item.tblItem}
    WHERE ${Item.colOwned} == 1;
    ''',
  'to buy':
  '''
    SELECT * FROM ${Item.tblItem}
    WHERE ${Item.colOwned} == 0;
    ''',
  'all':
  '''
    SELECT * FROM ${Item.tblItem};
    ''',
};

int tempMin = -3;
int tempMax = 9;

Map<String, String> sqlMapOutfit = {
  'all':
  '''
    SELECT ${Outfit.tblLink}.${Outfit.colOutfitId},
           GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}   , ',')
             AS ${Outfit.colItemIds},
           GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
             AS ${Outfit.colImageNames}
    FROM ${Outfit.tblLink}
      INNER JOIN ${Item.tblItem}
        ON ${Outfit.tblLink}.${Item.colItemId}
         = ${Item.tblItem}.${Item.colItemId}
    GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId};
    ''',
  'possible':
  '''
    SELECT ${Outfit.colOutfitId},
           ${Outfit.colItemIds},
           ${Outfit.colImageNames}
    FROM(
      SELECT ${Outfit.tblLink}.${Outfit.colOutfitId},
             GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}, ',')
               AS ${Outfit.colItemIds},
             GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
               AS ${Outfit.colImageNames},
             MIN(${Item.tblItem}.${Item.colOwned})
               AS ${Outfit.colPossible}
      FROM ${Outfit.tblLink}
        INNER JOIN ${Item.tblItem}
          ON ${Outfit.tblLink}.${Item.colItemId}
           = ${Item.tblItem}.${Item.colItemId}
      GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId}
    )
    WHERE ${Outfit.colPossible} == 1;
    ''',
  'today':
  '''
    SELECT ${Outfit.colOutfitId},
           ${Outfit.colItemIds},
           ${Outfit.colImageNames}
    FROM (
      SELECT ${Outfit.colOutfitId},
             ${Outfit.colItemIds},
             ${Outfit.colImageNames},
             CASE
               WHEN ${Outfit.colMaxIns} == 0 THEN 25
               WHEN ${Outfit.colMaxIns} == 1 THEN 21
               WHEN ${Outfit.colMaxIns} == 2 THEN 18
               WHEN ${Outfit.colMaxIns} == 3 THEN 17
               WHEN ${Outfit.colMaxIns} == 4 THEN 16
               WHEN ${Outfit.colMaxIns} == 5 THEN 15
               WHEN ${Outfit.colMaxIns} == 6 THEN 14
               WHEN ${Outfit.colMaxIns} == 7 THEN 12
               WHEN ${Outfit.colMaxIns} >= 8 THEN -100
             END AS ${Outfit.colTempMin},
             CASE
               WHEN ${Outfit.colMinIns} == 0 THEN 100
               WHEN ${Outfit.colMinIns} == 1 THEN 25
               WHEN ${Outfit.colMinIns} == 2 THEN 22 
               WHEN ${Outfit.colMinIns} == 3 THEN 20
               WHEN ${Outfit.colMinIns} == 4 THEN 19
               WHEN ${Outfit.colMinIns} == 5 THEN 18
               WHEN ${Outfit.colMinIns} == 6 THEN 17
               WHEN ${Outfit.colMinIns} == 7 THEN 15
               WHEN ${Outfit.colMinIns} >= 8 THEN 12
             END AS ${Outfit.colTempMax}
      FROM(
        SELECT ${Outfit.tblLink}.${Outfit.colOutfitId},
               GROUP_CONCAT(${Item.tblItem}.${Item.colItemId}, ',')
                 AS ${Outfit.colItemIds},
               GROUP_CONCAT(${Item.tblItem}.${Item.colImageName}, ',')
                 AS ${Outfit.colImageNames},
               MIN(${Item.tblItem}.${Item.colOwned})
                 AS ${Outfit.colPossible},
               SUM(${Item.tblItem}.${Item.colInsulation})
                 AS ${Outfit.colMaxIns},
               SUM(${Item.tblItem}.${Item.colInsulation}
                   * ${Item.tblItem}.${Item.colRemovable})
                 AS ${Outfit.colMinIns}
        FROM ${Outfit.tblLink}
          INNER JOIN ${Item.tblItem}
            ON ${Outfit.tblLink}.${Item.colItemId}
             = ${Item.tblItem}.${Item.colItemId}
        GROUP BY ${Outfit.tblLink}.${Outfit.colOutfitId}
      )
      WHERE ${Outfit.colPossible} == 1
    )
    WHERE ${Outfit.colTempMin} <= $tempMin
      AND ${Outfit.colTempMax} >= $tempMax;
    ''',
};
