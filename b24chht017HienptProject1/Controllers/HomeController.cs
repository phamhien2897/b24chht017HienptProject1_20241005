using b24chht017HienptProject1.Models;
using b24chht017HienptProject1.Service;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Text;

namespace b24chht017HienptProject1.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            DBConnect db = new DBConnect();
            string query = "select * from Personnel";
            var dttable = db.Select(query);
            var listPersonnel = new List<Personnel>();
            if (dttable != null)
            {
                for (int i = 0; i < dttable.Rows.Count; i++)
                {
                    Personnel Personnel = new Personnel();
                    Personnel.PersonnelID = Convert.ToInt32(dttable.Rows[i]["PersonnelID"]);
                    Personnel.CMT = dttable.Rows[i]["CMT"].ToString();
                    Personnel.FullName = dttable.Rows[i]["FullName"].ToString();
                    Personnel.CodePersonnel = dttable.Rows[i]["CodePersonnel"].ToString();
                    Personnel.Address = dttable.Rows[i]["Address"].ToString();
                    Personnel.Training_Level = Convert.ToInt32(dttable.Rows[i]["Training_Level"]);
                    Personnel.PhoneNumber = dttable.Rows[i]["PhoneNumber"].ToString();
                    Personnel.Type = Convert.ToInt32(dttable.Rows[i]["Type"]);


                    Personnel.DateOfBirth = Convert.ToDateTime(dttable.Rows[i]["DateOfBirth"]);
                    Personnel.WorkStartDate = Convert.ToDateTime(dttable.Rows[i]["WorkStartDate"]);

                    listPersonnel.Add(Personnel);
                }
            }    

            return View(listPersonnel);
        }

        public IActionResult Report ()
        {

            DBConnect db = new DBConnect();
            string query = "select PatientID,FullName,CodePatient from  Patient";

            var dttable = db.Select(query);
            var listPatient = new List<Patient>();
            if (dttable != null)
            {
                for (int i = 0; i < dttable.Rows.Count; i++)
                {
                    Patient c = new Patient();
                    c.PatientID = Convert.ToInt32(dttable.Rows[i]["PatientID"]);
                    c.FullName = dttable.Rows[i]["FullName"].ToString();
                    c.CodePatient = dttable.Rows[i]["CodePatient"].ToString();
                    listPatient.Add(c);
                }
            }
            ViewBag.listPatient = listPatient;
            return View();
        }

        public IActionResult Cau1(string TuNgay , string DenNgay)
        {
            DBConnect db = new DBConnect();
            //string fromDate = TuNgay;
            //string toDate = DenNgay;

            StringBuilder sQuery = new StringBuilder();
            sQuery.Append("select ");
            sQuery.Append("chitietkham.DiseaseID IdBenh, ");
            sQuery.Append("(select NameDisease from Disease where DiseaseID =  chitietkham.DiseaseID) TenBenh, ");
            sQuery.Append("count(0) solankham ");
            sQuery.Append(" from Patient_Visits KhamBenh ");
            sQuery.Append("INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID ");
            sQuery.Append(" where KhamBenh.StartDate BETWEEN '" + TuNgay + " 00:00:00' and '"+ DenNgay + " 23:59:59'");
            sQuery.Append(" group by IdBenh");
            string query = sQuery.ToString();

            var dttable = db.Select(query);
            var listCau1 = new List<Cau1>();
            if (dttable != null)
            {
                for (int i = 0; i < dttable.Rows.Count; i++)
                {
                    Cau1 c = new Cau1();
                    c.IdBenh = Convert.ToInt32(dttable.Rows[i]["IdBenh"]);
                    c.TenBenh = dttable.Rows[i]["TenBenh"].ToString();
                    c.solankham = Convert.ToInt32(dttable.Rows[i]["solankham"]);
                    listCau1.Add(c);
                }
            }

            return PartialView(listCau1);
        }

        public IActionResult Cau2(string TuNgay, string DenNgay)
        {
            DBConnect db = new DBConnect();
            //string fromDate = TuNgay;
            //string toDate = DenNgay;

            StringBuilder sQuery = new StringBuilder();
            sQuery.Append("select a.* , (((select bonus from Salary where Type_PersonnelID = a.type) *  a.solankham ) +(select Salary from Salary where Type_PersonnelID = a.type) ) BangLuong from ( ");
            sQuery.Append(" select nv.fullname as TenNhanVien, ");
            sQuery.Append("  case WHEN  nv.type = 1 then 'Bác sĩ' else 'Y tá' end ChucVu, ");
            sQuery.Append("   case when nv.Type = 2 then (select count(0) from Patient_Visits_Detail chitietkham WHERE  chitietkham.NurseID = nv.personnelID and chitietkham.StartDate BETWEEN '" + TuNgay + " 00:00:00' and '" + DenNgay + " 23:59:59' )  ");
          
            sQuery.Append("   when nv.Type = 1 then IFNULL( ( select  IFNULL(SUM(a.solankhamxong),0)  from (  ");
            sQuery.Append("   select chitietkham.DoctorID, chitietkham.NurseID,  ");
            sQuery.Append(" case WHEN KhamBenh.`STATUS` = 2 then 1 ELSE 0 end solankhamxong  ");
            sQuery.Append("  from Patient_Visits KhamBenh   ");
            sQuery.Append("  INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID ");
            sQuery.Append("  where chitietkham.DoctorID = nv.personnelID and  KhamBenh.StartDate BETWEEN '" + TuNgay + " 00:00:00' and '" + DenNgay + " 23:59:59'  ");
            sQuery.Append("  )A group by a.DoctorID) ,0)  else 0    end solankham,  nv.type  from personnel nv)A  ");
            string query = sQuery.ToString();

            var dttable = db.Select(query);
            var listCau2 = new List<Cau2>();
            if (dttable != null)
            {
                for (int i = 0; i < dttable.Rows.Count; i++)
                {
                    Cau2 c = new Cau2();
                    c.TenNhanVien = dttable.Rows[i]["TenNhanVien"].ToString();
                    c.ChucVu = dttable.Rows[i]["ChucVu"].ToString();
                    c.solankham = Convert.ToInt32(dttable.Rows[i]["solankham"]);
                    c.BangLuong = Convert.ToInt32(dttable.Rows[i]["BangLuong"]);
                    listCau2.Add(c);
                }
            }

            return PartialView(listCau2);
        }

        public IActionResult Cau3(int PatientID)
        {
            DBConnect db = new DBConnect();
            //string fromDate = TuNgay;
            //string toDate = DenNgay;

            StringBuilder sQuery = new StringBuilder();
            sQuery.Append("  select KhamBenh.PatientID IdBenhNhan, ");
            sQuery.Append(" (select FullName from Patient where PatientID =  KhamBenh.PatientID) TenBenhNhan, ");
            sQuery.Append(" (select NameDisease from Disease where DiseaseID =  chitietkham.DiseaseID) TenBenh, ");
            sQuery.Append(" KhamBenh.StartDate NgayKhamLanDau, ");
            sQuery.Append(" chitietkham.StartDate NgayKham, ");
            sQuery.Append(" case when KhamBenh.`STATUS` = 1 then 'Vẫn đang khám' ");
            sQuery.Append("     when KhamBenh.`STATUS` = 2 then 'Đã khỏi' end TinhTrangBenh ");
            sQuery.Append("  from Patient_Visits KhamBenh  ");
            sQuery.Append(" INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID ");
            sQuery.Append("  where KhamBenh.PatientID = "+ PatientID);

            string query = sQuery.ToString();

            var dttable = db.Select(query);
            var listCau3 = new List<Cau3>();
            if (dttable != null)
            {
                for (int i = 0; i < dttable.Rows.Count; i++)
                {
                    Cau3 c = new Cau3();
                    c.IdBenhNhan = Convert.ToInt32(dttable.Rows[i]["IdBenhNhan"]);
                    c.TenBenhNhan = dttable.Rows[i]["TenBenhNhan"].ToString();
                    c.TenBenh = dttable.Rows[i]["TenBenh"].ToString();
                    c.TinhTrangBenh = dttable.Rows[i]["TinhTrangBenh"].ToString();
                    c.NgayKhamLanDau = Convert.ToDateTime(dttable.Rows[i]["NgayKhamLanDau"]);
                    c.NgayKham = Convert.ToDateTime(dttable.Rows[i]["NgayKham"]);
                    listCau3.Add(c);
                }
            }

            return PartialView(listCau3);
        }


        public IActionResult Cau4(string TuNgay, string DenNgay)
        {
            DBConnect db = new DBConnect();
            double dtKB = 0;
            double dtBT = 0;

         

            string queryDT = " select sum(expense) DoanhThuKham from Patient_Visits_Detail WHERE StartDate  BETWEEN '" + TuNgay + " 00:00:00' and '" + DenNgay + " 23:59:59'  ";
           var dttableDT = db.Select(queryDT);
            if (dttableDT != null)
            {
                for (int i = 0; i < dttableDT.Rows.Count; i++)
                {
                    dtKB = Convert.ToDouble(dttableDT.Rows[i]["DoanhThuKham"]);
                }
            }

            StringBuilder sQuery = new StringBuilder();
            sQuery.Append(" SELECT  sum( ( ChiTietThuoc.Count * ChiTietThuoc.Expense )) DoanhThuThuoc  ");
            sQuery.Append(" FROM PrescriptionDetail ChiTietThuoc  ");
            sQuery.Append("   INNER JOIN Prescription DonThuoc on ChiTietThuoc.PrescriptionID = DonThuoc.PrescriptionID ");
            sQuery.Append("   INNER JOIN Patient_Visits_Detail KhamBenh on KhamBenh.Patient_Visits_DetailID = DonThuoc.Patient_VisitsID ");
            sQuery.Append(" WHERE KhamBenh.StartDate  BETWEEN '" + TuNgay + " 00:00:00' and '" + DenNgay + " 23:59:59'  ");
            sQuery.Append("  ");

            string queryBT = sQuery.ToString(); 
            var dttableBT = db.Select(queryBT);


            if (dttableBT != null)
            {
                for (int i = 0; i < dttableBT.Rows.Count; i++)
                {
                    dtKB = Convert.ToDouble(dttableBT.Rows[i]["DoanhThuThuoc"]);
                }
            }


            ViewBag.dtKB = dtKB;
            ViewBag.dtBT = dtBT;

            return PartialView();
        }


        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
