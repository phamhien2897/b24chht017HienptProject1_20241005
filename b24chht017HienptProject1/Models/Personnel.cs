namespace b24chht017HienptProject1.Models
{
    public class Personnel
    {
        public int PersonnelID { get; set; }
        public string CMT { get; set; }
        public string FullName { get; set; }
        public string CodePersonnel { get; set; }
        public DateTime? DateOfBirth { get; set; }
        public string Address { get; set; }
        public DateTime? WorkStartDate { get; set; }
        public int Training_Level { get; set; }
        public string PhoneNumber { get; set; }
        public int Type { get; set; }
        public int Status { get; set; }
    }
}
