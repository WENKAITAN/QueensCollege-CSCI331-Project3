package net.codejava.sql;
//import javax.swing.;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class test2 {
	 public static void main (String[] args)
	    {
	        try
	        {
	            Connection connection = null;
	            try {
	                connection = DriverManager.getConnection("jdbc:sqlserver://localhost:13001;databaseName=QueensClassSchedule;user=sa;password=PH@123456789;encrypt=false");
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	            Statement statement = connection.createStatement();

	            ResultSet resultset = statement.executeQuery
	                    (
//    		Use jdbc to run LoadQueensCourseSchedule and load the output into JTable for presentation in the video
	                    		"exec [Project3].[LoadQueensCourseSchedule] @UserAuthorizationKey =2;"//
	                    );

	            String s = "ScheduleID,ClassId,UserAuthorizationKey,DateAdded,DateOfLastUpdate";
	            String[] columns = s.split(",");

	            DefaultTableModel dtm = new DefaultTableModel(columns, 0);
	            JTable jt = new JTable(dtm);
	            JFrame jf = new JFrame();
	            JScrollPane jsp = new JScrollPane(jt);
	            jf.add(jsp);
	            jf.setSize(900, 500);
	            jf.setVisible(true);

	            while(resultset.next())
	            {
	                while(resultset.next())
	                {
	                    String[] rows = new String[columns.length];
	                    for (int i = 0; i < columns.length; i++) { rows[i] = resultset.getString(columns[i]); }
	                    dtm.addRow(rows);
	                }
	            }
	        }
	        catch (SQLException e) { e.printStackTrace(); }
	    }
}