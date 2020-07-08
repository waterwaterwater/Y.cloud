const ycsdk = require("yandex-cloud/api/compute/v1");
const FOLDER_ID = process.env.FOLDER_ID;
async function handler(event, context) {
    const snapshotService = new ycsdk.SnapshotService();
    const diskService = new ycsdk.DiskService();
    const diskList = await diskService.list({
        folderId: FOLDER_ID,
    });
    for (const disk of diskList.disks) {
        if ('snapshot' in disk.labels) {
            snapshotService.create({
                folderId: FOLDER_ID,
                diskId: disk.id
            });
        }
    }
}
exports.handler = handler;
