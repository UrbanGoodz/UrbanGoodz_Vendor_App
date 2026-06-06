import '../models/medical_courier_job_model.dart';

class MedicalCourierApiService {
  Future<List<MedicalCourierJobModel>> getJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return const [
      MedicalCourierJobModel(id:'1', title:'STAT Specimen Transfer', deliveryType:'STAT Specimen Route', status:'available', pickupLabel:'Houston Lab', dropoffLabel:'Medical Center', payLabel:'\$45', scheduleLabel:'Immediate', complianceLabel:'Chain of custody', icon:null as dynamic, statDelivery:true),
      MedicalCourierJobModel(id:'2', title:'Blood Product Delivery', deliveryType:'Blood Transport', status:'available', pickupLabel:'Regional Bank', dropoffLabel:'Hospital', payLabel:'\$60', scheduleLabel:'Priority', complianceLabel:'Temperature monitored', icon:null as dynamic),
      MedicalCourierJobModel(id:'3', title:'Pharmaceutical Route', deliveryType:'Pharmaceutical Delivery', status:'available', pickupLabel:'Pharmacy Hub', dropoffLabel:'Clinic Network', payLabel:'\$120', scheduleLabel:'Daily', complianceLabel:'Controlled handling', icon:null as dynamic),
      MedicalCourierJobModel(id:'4', title:'Medical Equipment Transfer', deliveryType:'Equipment Route', status:'available', pickupLabel:'Warehouse', dropoffLabel:'Provider Office', payLabel:'\$90', scheduleLabel:'Scheduled', complianceLabel:'Signature required', icon:null as dynamic),
      MedicalCourierJobModel(id:'5', title:'Medical Records Run', deliveryType:'Records Delivery', status:'available', pickupLabel:'Records Center', dropoffLabel:'Legal Office', payLabel:'\$55', scheduleLabel:'Same Day', complianceLabel:'HIPAA handling', icon:null as dynamic),
    ];
  }
}
