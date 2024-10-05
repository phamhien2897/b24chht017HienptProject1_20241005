-- -- 1. Tạo bảng
CREATE DATABASE b24chht017_project1;
use b24chht017_project1;


-- -- Bảng quản lý bác sỹ, y tá
CREATE TABLE `personnel`  (
  `PersonnelID` int NOT NULL,
  `CMT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `FullName` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `CodePersonnel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `DateOfBirth` date NULL DEFAULT NULL,
  `Address` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `WorkStartDate` date NULL DEFAULT NULL,
  `Skill_Level` varchar(30) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `Training_Level` int NULL DEFAULT NULL comment '1 la đại học, 2 là thạc sỹ, 3 là tiến sỹ',
  `PhoneNumber` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Type` int NULL DEFAULT NULL,
  `Status` int NULL DEFAULT NULL,
  PRIMARY KEY (`PersonnelID`) USING BTREE
) ;
-- -- Loại nhân viên
CREATE TABLE `type_personnel`  (
  `Type_PersonnelID` int NOT NULL,
  `Description` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`Type_PersonnelID`) USING BTREE
);
-- -- Danh mục loại bệnh
CREATE TABLE `disease`  (
  `DiseaseID` int NOT NULL,
  `NameDisease` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `Description` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`DiseaseID` DESC) USING BTREE
) ;
-- -- bảng nối bác sỹ và danh mục bệnh
CREATE TABLE `personnel_disease`  (
  `Personnel_DiseaseID` int NOT NULL,
  `PersonnelID` int NULL DEFAULT NULL,
  `DiseaseID` int NULL DEFAULT NULL,
  `WorkStartDate` date NULL DEFAULT NULL,
  `Description` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`Personnel_DiseaseID`) USING BTREE
);
-- -- bảng  lương
CREATE TABLE `salary`  (
  `SalaryID` int NOT NULL,
  `Type_PersonnelID` int NULL DEFAULT NULL,
  `Salary` float NULL DEFAULT NULL,
  `bonus` float NULL DEFAULT NULL,
  PRIMARY KEY (`SalaryID`) USING BTREE
);

-- bảng đơn thuốc
CREATE TABLE `prescription`  (
  `PrescriptionID` int NOT NULL,
  `Patient_VisitsID` int NULL DEFAULT NULL,
  PRIMARY KEY (`PrescriptionID`) USING BTREE
) ;

-- -- bảng chi tiết đơn thuốc
CREATE TABLE `prescriptiondetail`  (
  `PrescriptionDetailID` int NOT NULL,
  `PrescriptionID` int NULL DEFAULT NULL,
  `MedicineID` int NULL DEFAULT NULL,
  `Count` int NULL DEFAULT NULL,
  `Expense` float NULL DEFAULT NULL,
  PRIMARY KEY (`PrescriptionDetailID`) USING BTREE
) ;

-- -- bảng quản lý thuốc
CREATE TABLE `medicine`  (
  `MedicineID` int NOT NULL,
  `CodeMedicine` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `NameMedicine` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `Description` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `BuyingPrice` float NULL DEFAULT NULL,
  `SellingPrice` float NULL DEFAULT NULL,
  PRIMARY KEY (`MedicineID` DESC) USING BTREE
) ;

-- -- bảng quản lý thông tin bệnh nhân
CREATE TABLE `patient`  (
  `PatientID` int NOT NULL,
  `CMT` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `FullName` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `CodePatient` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `DateOfBirth` date NULL DEFAULT NULL,
  `Address` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `PhoneNumber` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `Status` int NULL DEFAULT NULL comment '1 là đang điều trị, 2 đã điều trị xong',
  PRIMARY KEY (`PatientID` DESC) USING BTREE
) ;

-- bảng quản lý bệnh án
CREATE TABLE `patient_visits`  (
  `Patient_VisitsID` int NOT NULL,
  `StartDate` datetime NULL DEFAULT NULL,
  `EndtDate` datetime NULL DEFAULT NULL,
  `PatientID` int NULL DEFAULT NULL,
  `STATUS` int NULL DEFAULT NULL comment '1 là đang tái khám trong tháng, 2 là đã kết thúc, 3 là khám lần 1',
  PRIMARY KEY (`Patient_VisitsID`) USING BTREE
) ;
 
 -- bảng quản lý thông tin chi tiết bệnh án
CREATE TABLE `patient_visits_detail`  (
  `Patient_Visits_DetailID` int NOT NULL,
  `Patient_VisitsID` int NULL DEFAULT NULL,
  `DiseaseID` int NULL DEFAULT NULL,
  `DoctorID` int NULL DEFAULT NULL,
  `NurseID` int NULL DEFAULT NULL,
  `Status` int NULL DEFAULT NULL,
  `StartDate` datetime NULL DEFAULT NULL,
  `EndDate` datetime NULL DEFAULT NULL,
  `Expense` float NULL DEFAULT NULL,
  PRIMARY KEY (`Patient_Visits_DetailID`) USING BTREE
);

-- -- Thông tin nối bảng
ALTER TABLE Personnel_Disease ADD CONSTRAINT FK_Personnel_Disease_Personnel FOREIGN KEY (PersonnelID) REFERENCES Personnel(PersonnelID);
-- nối vs bảng Disease 
ALTER TABLE Personnel_Disease ADD CONSTRAINT FK_Personnel_Disease_Disease FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID);


-- Patient_Visits
ALTER TABLE Patient_Visits ADD CONSTRAINT FK_Patient_Visits_Patient FOREIGN KEY (PatientID) REFERENCES Patient(PatientID);

-- Patient_Visits_Detail
ALTER TABLE Patient_Visits_Detail ADD CONSTRAINT FK_Patient_Visits_Detail_Patient_Visits FOREIGN KEY (Patient_VisitsID) REFERENCES Patient_Visits(Patient_VisitsID);

-- -- Bảng đơn thuốc Prescription
ALTER TABLE Prescription ADD CONSTRAINT FK_Prescription_Patient_Visits_Detail FOREIGN KEY (Patient_VisitsID) REFERENCES Patient_Visits_Detail(Patient_Visits_DetailID);

-- --  Bảng đơn thuốc chi tiết  PrescriptionDetail
ALTER TABLE PrescriptionDetail ADD CONSTRAINT FK_PrescriptionDetail_Prescription FOREIGN KEY (PrescriptionID) REFERENCES Prescription(PrescriptionID);

-- --  Bảng Personnel  
ALTER TABLE Personnel ADD CONSTRAINT FK_Personnel_Type_Personnel FOREIGN KEY (Type) REFERENCES Type_Personnel(Type_PersonnelID);
-- -- Bảng lương
ALTER TABLE Salary ADD CONSTRAINT FK_Salary_Type_Personnel FOREIGN KEY (Type_PersonnelID) REFERENCES Type_Personnel(Type_PersonnelID);

-- -- 2. Insert dữ liệu mẫu
INSERT INTO `disease` VALUES (3, 'Bệnh gãy xương tay', 'Bị gãy tay');
INSERT INTO `disease` VALUES (2, 'Bệnh đau dạ dày', 'Bệnh đau dạ dày');
INSERT INTO `disease` VALUES (1, 'Bệnh viêm xoang', 'Bệnh viêm xoang');

INSERT INTO `medicine` VALUES (5, 'T00005', 'Thuốc chữa xoang 2', 'Thuốc chữa xoang', 20000, 25000);
INSERT INTO `medicine` VALUES (4, 'T00004', 'Thuốc chữa xoang 1', 'Thuốc chữa xoang', 12000, 20000);
INSERT INTO `medicine` VALUES (3, 'T00003', 'Thuốc đau bụng 3', 'Thuốc chữa đau bụng', 10000, 15000);
INSERT INTO `medicine` VALUES (2, 'T00002', 'Thuốc đau bụng 2', 'Thuốc chữa đau bụng', 10000, 15000);
INSERT INTO `medicine` VALUES (1, 'T00001', 'Thuốc đau bụng 1', 'Thuốc chữa đau bụng', 10000, 15000);

INSERT INTO `patient` VALUES (4, '041097005002', 'Bệnh nhân 4', 'BN000004', '2024-01-01', 'Cầu giấy, Hà Nội', '09457777724', 1);
INSERT INTO `patient` VALUES (3, '041097005003', 'Bệnh nhân 3', 'BN000003', '2024-01-01', 'Cầu giấy, Hà Nội', '0945777773', 1);
INSERT INTO `patient` VALUES (2, '041097005002', 'Bệnh nhân 2', 'BN000002', '2024-01-01', 'Cầu giấy, Hà Nội', '0945777772', 1);
INSERT INTO `patient` VALUES (1, '041097005001', 'Bệnh nhân 1', 'BN000001', '2024-01-01', 'Cầu giấy, Hà Nội', '0945777777', 1);


INSERT INTO `patient_visits` VALUES (1, '2024-10-01 08:00:00', NULL, 1, 1);
INSERT INTO `patient_visits` VALUES (2, '2024-10-01 08:00:00', NULL, 2, 1);
INSERT INTO `patient_visits` VALUES (3, '2024-10-01 08:00:00', '2024-10-01 09:00:00', 3, 2);
INSERT INTO `patient_visits` VALUES (4, '2024-10-01 09:00:00', '2024-10-01 10:00:00', 4, 2);

INSERT INTO `patient_visits_detail` VALUES (1, 1, 1, 1, 4, 2, '2024-10-01 08:00:00', '2024-10-01 08:00:00', 1000000);
INSERT INTO `patient_visits_detail` VALUES (2, 1, 2, 1, 4, 2, '2024-10-02 08:00:00', '2024-10-02 09:00:00', 500000);
INSERT INTO `patient_visits_detail` VALUES (3, 2, 1, 1, 4, 2, '2024-10-03 08:00:00', '2024-10-03 09:00:00', 800000);
INSERT INTO `patient_visits_detail` VALUES (4, 3, 1, 1, 4, 2, '2024-10-04 08:00:00', '2024-10-04 09:00:00', 1000000);

INSERT INTO `type_personnel` VALUES (1, 'Bác sĩ');
INSERT INTO `type_personnel` VALUES (2, 'Y tá');

INSERT INTO `personnel` VALUES (1, '031097005001', 'Bác sĩ 1', 'BS0001', '1997-01-01', 'Hai Bà Trưng, Hà Nội', '2022-01-01', 'Bác sỹ bậc 1', 2, '0945677888', 1, 1);
INSERT INTO `personnel` VALUES (2, '031097005002', 'Bác sĩ 2', 'BS0002', '1997-01-02', 'Hai Bà Trưng, Hà Nội', '2022-01-01', 'Bác sỹ Bậc 2', 2, '0945677888', 1, 1);
INSERT INTO `personnel` VALUES (3, '031097005003', 'Bác sĩ 3', 'BS0003', '1997-01-03', 'Hai Bà Trưng, Hà Nội', '2022-01-01', 'Bác sỹ Bậc 3', 2,'0945677888', 1, 1);
INSERT INTO `personnel` VALUES (4, '031097005004', 'Y Tá 1', 'YT0001', '1997-01-01', 'Hai Bà Trưng, Hà Nội', '2022-01-01', '',2, '0945677888', 2, 1);
INSERT INTO `personnel` VALUES (5, '031097005005', 'Y Tá 2', 'YT0002', '1997-01-02', 'Hai Bà Trưng, Hà Nội', '2022-01-01', '',2, '0945677888', 2, 1);

INSERT INTO `personnel_disease` VALUES (1, 1, 1, '2022-01-01', 'bác sĩ chuyên khoa');
INSERT INTO `personnel_disease` VALUES (2, 1, 2, '2022-01-01', 'bác sĩ chuyên khoa');
INSERT INTO `personnel_disease` VALUES (3, 2, 3, '2022-01-01', 'bác sĩ chuyên khoa');

INSERT INTO `prescription` VALUES (1, 1);
INSERT INTO `prescription` VALUES (2, 2);
INSERT INTO `prescription` VALUES (3, 2);
INSERT INTO `prescription` VALUES (4, 3);

INSERT INTO `prescriptiondetail` VALUES (1, 1, 4, 3, 12000);
INSERT INTO `prescriptiondetail` VALUES (2, 1, 5, 3, 20000);
INSERT INTO `prescriptiondetail` VALUES (3, 2, 1, 1, 30000);
INSERT INTO `prescriptiondetail` VALUES (4, 2, 2, 3, 40000);
INSERT INTO `prescriptiondetail` VALUES (5, 3, 1, 3, 20000);
INSERT INTO `prescriptiondetail` VALUES (6, 4, 1, 2, 20000);




INSERT INTO `salary` VALUES (1, 1, 7000000, 1000000);
INSERT INTO `salary` VALUES (2, 2, 5000000, 200000);

-- -- 3. Truy vấn dữ liệu
-- Liệt kê danh sách các loại bệnh được các bệnh nhân mắc phải trong một tháng cho trước, các bệnh được sắp xếp theo thứ tự số bệnh nhân đến khám giảm dần.
select 
chitietkham.DiseaseID IdBenh,
(select NameDisease from Disease where DiseaseID =  chitietkham.DiseaseID) TenBenh,
count(0) solankham
 from Patient_Visits KhamBenh 
INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID
 where KhamBenh.StartDate BETWEEN '2024-10-01 00:00:00' and '2024-10-30 23:59:59'
 group by IdBenh;

 -- Tính lương của các Bác sỹ và y tá trong tháng tính đến thời điểm hiện tại
 select a.* , (((select bonus from Salary where Type_PersonnelID = a.type) *  a.solankham ) +(select Salary from Salary where Type_PersonnelID = a.type) ) BangLuong from (
 select nv.fullname as TenNhanVien,
  -- (select Description from type_personnel where Type_PersonnelID = nv.type)
   case WHEN  nv.type = 1 then 'Bác sĩ' else 'Y tá' end ChucVu,
        case when nv.Type = 2 then (select count(0) from Patient_Visits_Detail chitietkham WHERE  chitietkham.NurseID = nv.personnelID and chitietkham.StartDate BETWEEN '2024-10-01 00:00:00' and '2024-10-30 23:59:59') 
         when nv.Type = 1 then IFNULL( ( select  IFNULL(SUM(a.solankhamxong),0)  from (
  select 
  chitietkham.DoctorID,
  chitietkham.NurseID,
case WHEN KhamBenh.`STATUS` = 2 then 1 ELSE 0 end solankhamxong
 from Patient_Visits KhamBenh 
INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID
 where chitietkham.DoctorID = nv.personnelID and  KhamBenh.StartDate BETWEEN '2024-10-01 00:00:00' and '2024-10-30 23:59:59'
 )A group by a.DoctorID) ,0)
        else 0 
        end solankham,
        nv.type
  from personnel nv)A;
 
 -- Hiển thị thông tin của một bệnh nhân nào đó cùng với tất cả các thông tin khám chữa bệnh của họ từ trước đến nay
 select KhamBenh.PatientID IdBenhNhan,
(select FullName from Patient where PatientID =  KhamBenh.PatientID) TenBenhNhan,
(select NameDisease from Disease where DiseaseID =  chitietkham.DiseaseID) TenBenh,
KhamBenh.StartDate NgayKhamLanDau,
chitietkham.StartDate NgayKham,
case when KhamBenh.`STATUS` = 1 then 'Vẫn đang khám' 
    when KhamBenh.`STATUS` = 2 then 'Đã khỏi' end TinhTrangBenh
 from Patient_Visits KhamBenh 
INNER JOIN Patient_Visits_Detail chitietkham on KhamBenh.Patient_VisitsID = chitietkham.Patient_VisitsID
 where KhamBenh.PatientID = 1;
 
 -- Tính Doanh thu của Phòng khám dựa trên số tiền khám/chữa bệnh của các bệnh nhân và số tiền bán thuốc trên các đơn thuốc.
  with DoanhThuKham as ( select sum(expense) DoanhThuKham from Patient_Visits_Detail WHERE StartDate  BETWEEN '2024-10-01 00:00:00' and '2024-10-30 23:59:59'),
  DoanhThuBanThuoc  as ( SELECT  sum( ( ChiTietThuoc.Count * ChiTietThuoc.Expense )) DoanhThuThuoc 
FROM PrescriptionDetail ChiTietThuoc 
  INNER JOIN Prescription DonThuoc on ChiTietThuoc.PrescriptionID = DonThuoc.PrescriptionID
  INNER JOIN Patient_Visits_Detail KhamBenh on KhamBenh.Patient_Visits_DetailID = DonThuoc.Patient_VisitsID
  WHERE KhamBenh.StartDate  BETWEEN '2024-10-01 00:00:00' and '2024-10-30 23:59:59')
  
  select dtK.DoanhThuKham,dtBT.DoanhThuThuoc , ( dtK.DoanhThuKham + dtBT.DoanhThuThuoc) TongDoanhThu from DoanhThuKham  dtK,DoanhThuBanThuoc  dtBT