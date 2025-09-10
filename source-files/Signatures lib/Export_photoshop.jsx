#target photoshop

// === НАСТРОЙКИ ===
var exportFolder = Folder.selectDialog("Выбери папку для экспорта PNG");
if (!exportFolder) exit();

var exportAsPNG8 = false;   // true = PNG-8, false = PNG-24
// ==================

// функция экспорта PNG
function savePNG24(docRef, outFile) {
    var opts = new ExportOptionsSaveForWeb();
    opts.format = SaveDocumentType.PNG;
    opts.PNG8 = false;           // false = PNG-24
    opts.transparency = true;
    opts.interlaced = false;
    opts.includeProfile = false; // не встраивать ICC-профиль
    docRef.exportDocument(outFile, ExportType.SAVEFORWEB, opts);
}

// обработка всех слоёв
function exportLayers(doc) {
    for (var i = 0; i < doc.layers.length; i++) {
        var layer = doc.layers[i];

        // если это группа — рекурсивно пройти по ней
        if (layer.typename === "LayerSet") {
            exportLayers(layer);
        } else {
            // дублируем документ
            var dup = doc.duplicate();

            // скрываем все слои
            hideAllLayers(dup);

            // включаем только текущий слой по имени
            var target = findLayerByName(dup, layer.name);
            if (target) target.visible = true;

            // мержим и сохраняем
            //dup.mergeVisibleLayers();

            // имя файла = имя слоя
            var safeName = layer.name.replace(/[\\\/:*?"<>|]/g, "_");
            var saveFile = new File(exportFolder + "/" + safeName + ".png");

            savePNG24(dup, saveFile);

            dup.close(SaveOptions.DONOTSAVECHANGES);
        }
    }
}

// скрыть все слои
function hideAllLayers(doc) {
    for (var i = 0; i < doc.layers.length; i++) {
        doc.layers[i].visible = false;
    }
}

// найти слой по имени (в копии документа)
function findLayerByName(doc, name) {
    for (var i = 0; i < doc.layers.length; i++) {
        if (doc.layers[i].name === name) return doc.layers[i];
    }
    return null;
}

// запуск
exportLayers(app.activeDocument);

alert("Экспорт завершён!");
